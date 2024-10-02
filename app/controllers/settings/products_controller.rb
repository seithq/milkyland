class Settings::ProductsController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update ]
  before_action :set_product, only: %i[ show edit update ]

  def index
    @pagy, @products = pagy get_scope(params)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_on_create edit_product_url(@product)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      redirect_on_update products_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def base_scope
      Product.recent_first
    end

    def search_methods
      []
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:group_id, :name, :article, :packing, :measurement_id, :expiration_in_days, :storage_conditions, :fat_fraction, :material_asset_id)
    end
end
