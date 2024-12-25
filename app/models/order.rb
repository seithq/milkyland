class Order < ApplicationRecord
  belongs_to :sales_channel
  belongs_to :client
  belongs_to :sales_point

  has_many :positions, dependent: :destroy
  has_many :consolidations, dependent: :destroy

  has_many :tracking_orders, dependent: :destroy

  enum :kind, %i[ planned unscheduled ], default: :planned
  enum :status, (%w[ in_planning in_delivery completed ] + Plan::SHARED).index_by(&:itself), default: :in_planning

  validates :preferred_date, presence: true, comparison: { greater_than_or_equal_to: Time.zone.today }

  after_create :add_to_plan, if: :planned?
  after_update :update_plan, if: :planned?

  after_destroy :deactivate_plans

  scope :filter_by_status, ->(status) { where status: status }
  scope :filter_by_client, ->(client_id) { where client_id: client_id }
  scope :filter_by_region, ->(region_id) { joins(:sales_point).where(sales_points: { region_id: region_id }) }
  scope :filter_by_id_or_client_or_sales_point, ->(query) { joins(:client).joins(:sales_point).where("LOWER(orders.id::text) LIKE ? OR LOWER(clients.name) LIKE ? OR LOWER(sales_points.name) LIKE ?", like(query), like(query), like(query)) }

  scope :active, ->() { where.not(status: %i[ completed cancelled ]) }

  scope :for_departure, ->() { where(kind: :planned, status: :produced).or(where(kind: :unscheduled, status: :in_planning)).order(:id) }

  def cancel
    update! status: :cancelled
  end

  def sum
    positions.sum(:total_sum)
  end

  def can_edit?
    in_planning?
  end

  def can_be_canceled?
    in_planning?
  end

  def eligible_promotions_for(product)
    promotions = Promotion.running.filter_by_eligible client_id: self.client_id, product_id: product.id
    promotions.sort_by { |promo| promo.calculate_discount_for product.price(by: self.sales_channel_id, client: self.client_id) }
  end

  def current_plan
    plans = Plan.where(id: self.consolidations.ordered.active.pluck(:plan_id))
    plans.first if plans.any?
  end

  def display_label
    "#{ id } - #{ client.name }"
  end

  private
    def add_to_plan
      transaction { assign_plan }
    end

    def update_plan
      transaction do
        if cancelled?
          deactivate_plans
        elsif preferred_date_previously_changed?
          assign_plan deactivate_current: true
        end
      end
    end

    def assign_plan(deactivate_current: false)
      plan = Plan.find_or_create_by production_date: self.preferred_date
      if plan.in_consolidation?
        deactivate_plans if deactivate_current
        plan.add self
      else
        move_to_next_plan
      end
    end

    def deactivate_plans
      self.consolidations.update_all active: false
    end

    def move_to_next_plan
      # В случае иного статуса передвигаем дату производства
      next_plan = Plan.after self.preferred_date
      # Дата = след доступная дата проиозводства или +1 день
      next_date = next_plan ? next_plan.production_date : self.preferred_date + 1.day
      # Сохраняем новую дату
      self.update preferred_date: next_date
    end
end
