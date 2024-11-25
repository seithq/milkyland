class Settings::SemiProductsController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update ]
  before_action :set_semi_product, only: %i[ show edit update ]

  def index
    @pagy, @semi_products = pagy get_scope(params)
  end

  def show
  end

  def new
    @semi_product = SemiProduct.new
  end

  def edit
  end

  def create
    @semi_product = SemiProduct.new(semi_product_params)

    if @semi_product.save
      redirect_on_create semi_products_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @semi_product.update(semi_product_params)
      redirect_on_update semi_products_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def base_scope
      SemiProduct.recent_first
    end

    def search_methods
      []
    end

    def set_semi_product
      @semi_product = SemiProduct.find(params.expect(:id))
    end

    def semi_product_params
      params.require(:semi_product).permit(:group_id, :name, :measurement_id, :expiration_in_days, :storage_conditions)
    end
end
