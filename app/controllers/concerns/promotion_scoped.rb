
module PromotionScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_promotion
  end

  private
    def set_promotion
      @promotion = Promotion.find(params[:promotion_id])
    end
end
