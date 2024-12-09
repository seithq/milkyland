class Transaction < ApplicationRecord
  include Directional

  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  belongs_to :bank_account
  belongs_to :article
  belongs_to :client, optional: true
  belongs_to :material_asset, optional: true

  belongs_to :linked_transaction, class_name: "Transaction", foreign_key: "linked_transaction_id", optional: true
  has_one :reverse_transaction, class_name: "Transaction", foreign_key: "linked_transaction_id"

  enum :status, %w[ pending confirmed completed cancelled ].index_by(&:itself), default: :pending

  validates :amount, presence: true, numericality: { greater_than: 0.0 }
  validates :planned_date, presence: true, comparison: { greater_than_or_equal_to: Date.current }
  validates :execution_date, presence: true, comparison: { greater_than_or_equal_to: :planned_date }, if: :completed?

  after_save :upgrade_status_if_needed

  scope :ordered, -> { order(planned_date: :desc, created_at: :desc) }
  scope :completed, -> { filter_by_status(:completed) }

  scope :filter_by_status, ->(status) { where status: status }
  scope :filter_by_client, ->(client_id) { where(client_id: client_id) }
  scope :filter_by_article, ->(article_id) { where(article_id: article_id) }
  scope :filter_by_creator, ->(creator_id) { where(creator_id: creator_id) }
  scope :filter_by_bank_account, ->(bank_account_id) { where(bank_account_id: bank_account_id) }
  scope :filter_by_material_asset, ->(material_asset_id) { where(material_asset_id: material_asset_id) }
  scope :filter_by_amount_from, ->(amount) { where("amount >= ?", amount) }
  scope :filter_by_amount_to, ->(amount) { where("amount <= ?", amount) }
  scope :filter_by_planned_date, ->(planned_date) { where(planned_date: planned_date) }

  def self.total_balance(bank_account_id: nil)
    query = <<-SQL
    CASE
        WHEN kind = 'income' THEN amount
        WHEN kind = 'expense' THEN -amount
        ELSE 0
    END#{' '}
    SQL

    scope = Transaction.completed
    scope = scope.filter_by_bank_account(bank_account_id) unless bank_account_id.nil?
    scope.sum(Arel.sql(query))
  end

  def self.transfer(creator_id, source_account_id, destination_account_id, amount, source_article_id, destination_article_id)
    transaction do
      expense_trx = Transaction.create! kind: :expense,
                                        bank_account_id: source_account_id,
                                        amount: amount,
                                        article_id: source_article_id,
                                        planned_date: Date.current,
                                        execution_date: Date.current,
                                        status: :completed,
                                        creator_id: creator_id

      income_trx = Transaction.create! kind: :income,
                                       bank_account_id: destination_account_id,
                                       amount: amount,
                                       article_id: destination_article_id,
                                       planned_date: Date.current,
                                       execution_date: Date.current,
                                       status: :completed,
                                       creator_id: creator_id,
                                       linked_transaction_id: expense_trx.id

      expense_trx.update! linked_transaction_id: income_trx.id
      [ expense_trx, income_trx ]
    end
  end

  private
    def upgrade_status_if_needed
      return unless pending?

      if income?
        update! status: :confirmed
      else
        update! status: :confirmed if article.bypass_control? || amount < article.min_amount
      end
    end
end
