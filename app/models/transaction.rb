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

  scope :filter_by_status, -> (status) { where status: status }
  scope :filter_by_client, -> (client_id) { where(client_id: client_id) }
  scope :filter_by_article, -> (article_id) { where(article_id: article_id) }
  scope :filter_by_creator, -> (creator_id) { where(creator_id: creator_id) }
  scope :filter_by_material_asset, -> (material_asset_id) { where(material_asset_id: material_asset_id) }
  scope :filter_by_amount_from, -> (amount) { where("amount >= ?", amount) }
  scope :filter_by_amount_to, -> (amount) { where("amount <= ?", amount) }
  scope :filter_by_planned_date, -> (planned_date) { where(planned_date: planned_date) }

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
