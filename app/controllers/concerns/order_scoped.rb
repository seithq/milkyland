module OrderScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_order
  end

  private
    def set_order
      @order = Order.find(params[:order_id])
    end
end
