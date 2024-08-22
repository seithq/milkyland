class Settings::PromotionsController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update destroy ]
  before_action :set_promotion, only: %i[ show edit update destroy ]

  def index
    @pagy, @promotions = pagy get_scope(params)
  end

  def show
  end

  def new
    @promotion = Promotion.new
  end

  def edit
  end

  def create
    @promotion = Promotion.new(promotion_params)

    if @promotion.save
      redirect_on_create edit_promotion_url(@promotion)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @promotion.update(promotion_params)
      redirect_on_update promotions_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @promotion.deactivate

    redirect_on_destroy promotions_url, text: t("actions.promo_deactivated")
  end

  private
    def base_scope
      Promotion.recent_first
    end

    def search_methods
      []
    end

    def set_promotion
      @promotion = Promotion.find(params[:id])
    end

    def promotion_params
      params.require(:promotion).permit(:name, :start_date, :end_date, :kind, :discount, :unlimited, :active)
    end
end
