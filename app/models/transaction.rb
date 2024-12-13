class Transaction < ApplicationRecord
  include Directional

  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  belongs_to :bank_account
  belongs_to :article
  belongs_to :contragent, polymorphic: true, optional: true
  belongs_to :material_asset, optional: true
  belongs_to :supply_order, optional: true

  belongs_to :linked_transaction, class_name: "Transaction", foreign_key: "linked_transaction_id", optional: true
  has_one :reverse_transaction, class_name: "Transaction", foreign_key: "linked_transaction_id", dependent: :nullify

  enum :status, %w[ pending confirmed completed cancelled ].index_by(&:itself), default: :pending

  validates :amount, presence: true, numericality: { greater_than: 0.0 }
  validates :planned_date, presence: true, comparison: { greater_than_or_equal_to: Date.current }
  validates :execution_date, presence: true, if: :completed?

  after_save :upgrade_status_if_needed

  scope :ordered, -> { order(planned_date: :desc, created_at: :desc) }
  scope :completed, -> { filter_by_status(:completed) }

  scope :filter_by_status, ->(status) { where status: status }
  scope :filter_by_client, ->(client_id) { where(contragent_type: "Client", contragent_id: client_id) }
  scope :filter_by_supplier, ->(supplier_id) { where(contragent_type: "Supplier", contragent_id: supplier_id) }
  scope :filter_by_article, ->(article_id) { where(article_id: article_id) }
  scope :filter_by_creator, ->(creator_id) { where(creator_id: creator_id) }
  scope :filter_by_bank_account, ->(bank_account_id) { where(bank_account_id: bank_account_id) }
  scope :filter_by_material_asset, ->(material_asset_id) { where(material_asset_id: material_asset_id) }
  scope :filter_by_amount_from, ->(amount) { where("amount >= ?", amount) }
  scope :filter_by_amount_to, ->(amount) { where("amount <= ?", amount) }
  scope :filter_by_planned_date, ->(planned_date) { where(planned_date: planned_date) }
  scope :filter_by_planned_date_start, ->(planned_date) { where(planned_date: planned_date..) }
  scope :filter_by_planned_date_end, ->(planned_date) { where(planned_date: ..planned_date) }

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

  def self.cash_flow(start_date, end_date, trunc_period = "day")
    query = <<-SQL
    WITH transaction_data AS (
        SELECT
            activity_types.name AS activity_type,
            activity_types.order_number AS activity_order,
            t.kind,
            financial_categories.name AS financial_category,
            articles.name AS article,
            DATE_TRUNC(:trunc_period, t.execution_date) AS report_period,
            SUM(
                CASE#{' '}
                    WHEN t.kind = 'income' THEN t.amount#{' '}
                    WHEN t.kind = 'expense' THEN -t.amount#{' '}
                END
            ) AS total_amount
        FROM transactions t
        INNER JOIN articles ON t.article_id = articles.id
        INNER JOIN financial_categories ON articles.financial_category_id = financial_categories.id
        INNER JOIN activity_types ON articles.activity_type_id = activity_types.id
        WHERE t.execution_date BETWEEN :start_date AND :end_date AND t.status = 'completed'
        GROUP BY#{' '}
            activity_types.name,
            activity_types.order_number,#{' '}
            t.kind,#{' '}
            financial_categories.name,#{' '}
            articles.name,#{' '}
            DATE_TRUNC(:trunc_period, t.execution_date)
    ),
    opening_closing_balances AS (
        SELECT#{' '}
            td.report_period,
            td.activity_type,
            td.kind,
            td.financial_category,
            td.article,
            (
                SELECT#{' '}
                    COALESCE(SUM(
                        CASE#{' '}
                            WHEN t.kind = 'income' THEN t.amount#{' '}
                            WHEN t.kind = 'expense' THEN -t.amount#{' '}
                        END
                    ), 0.0)
                FROM transactions t
                WHERE t.execution_date < td.report_period
        ) AS opening_balance,
        (
            SELECT#{' '}
                COALESCE(SUM(
                    CASE#{' '}
                        WHEN t.kind = 'income' THEN t.amount#{' '}
                        WHEN t.kind = 'expense' THEN -t.amount#{' '}
                    END
                ), 0.0)
            FROM transactions t
            WHERE t.execution_date <= DATE_TRUNC(:trunc_period, td.report_period) + INTERVAL :interval - INTERVAL '1 day'
        ) AS closing_balance
        FROM transaction_data td
    )
    SELECT#{' '}
        td.activity_type,
        td.kind,
        td.financial_category,
        td.article,
        td.report_period,
        td.total_amount,
        ob.opening_balance,
        ob.closing_balance
    FROM transaction_data td
    LEFT JOIN opening_closing_balances ob
    ON td.report_period = ob.report_period
    AND td.activity_type = ob.activity_type
    AND td.kind = ob.kind
    AND td.financial_category = ob.financial_category
    AND td.article = ob.article
    ORDER BY td.activity_order, td.report_period
    SQL

    find_by_sql([ query, { start_date:, end_date:, trunc_period:, interval: "1 #{ trunc_period }" } ])
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
