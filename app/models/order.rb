class Order < ApplicationRecord
  belongs_to :sales_channel
  belongs_to :client
  belongs_to :sales_point

  has_many :positions, dependent: :destroy

  enum :kind, %i[ planned unscheduled ], default: :planned
  enum :status, %w[ in_planning in_production in_delivery completed cancelled ].index_by(&:itself), default: :in_planning

  validates :preferred_date, presence: true, comparison: { greater_than_or_equal_to: Time.zone.today }

  after_create :add_to_plan
  after_save :update_plan

  scope :filter_by_status, ->(status) { where status: status }
  scope :filter_by_id_or_client_or_sales_point, ->(query) { joins(:client).joins(:sales_point).where("LOWER(orders.id::text) LIKE ? OR LOWER(clients.name) LIKE ? OR LOWER(sales_points.name) LIKE ?", like(query), like(query), like(query)) }

  scope :active, ->() { where.not(status: %i[ completed cancelled ]) }

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
    promotions.sort_by { |promo| promo.calculate_discount_for product.price(by: self.sales_channel_id) }
  end

  private
    def add_to_plan
      transaction do
        plan = Plan.find_or_create_by(production_date: self.preferred_date)

        # Новый план или план на стадии сбора заявок
        if plan.in_consolidation?
          # Добавляем в план
        else
          move_to_next_plan
        end
      end
    end

    def update_plan
      if cancelled?
        # Удаляем со старого
      elsif preferred_date_previously_changed?
        plan = Plan.find_or_create_by(production_date: self.preferred_date)

        # Новый план или план на стадии сбора заявок
        if plan.in_consolidation?
          # Добавляем в план
          # Удаляем со старого
        else
          move_to_next_plan
        end
      end
    end

    def move_to_next_plan
      # В случае иного статуса передвигаем дату производства
      next_plan = Plan.after self.preferred_date
      # Дата = след доступная дата проиозводства или +1 день
      next_date = next_plan ? next_plan.production_date : self.preferred_date + 1.day
      # Сохраняем новую дату
      self.update(preferred_date: next_date)
    end
end
