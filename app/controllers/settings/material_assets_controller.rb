class Settings::MaterialAssetsController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update ]
  before_action :set_material_asset, only: %i[ show edit update ]

  def index
    @pagy, @material_assets = pagy get_scope(params)
  end

  def show
  end

  def new
    @material_asset = MaterialAsset.new
  end

  def edit
  end

  def create
    @material_asset = MaterialAsset.new(material_asset_params)

    if @material_asset.save
      redirect_on_create material_assets_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @material_asset.update(material_asset_params)
      redirect_on_update material_assets_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def base_scope
      MaterialAsset.recent_first
    end

    def search_methods
      []
    end

    def set_material_asset
      @material_asset = MaterialAsset.find(params[:id])
    end

    def material_asset_params
      params.require(:material_asset).permit(:name, :category_id, :supplier_id, :article, :entry_price, :packing, :measurement_id, :delivery_time_in_days)
    end
end
