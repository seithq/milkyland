class Procurements::SupplyMaterialAssetsController < ApplicationController
  before_action :set_material_asset, only: :show

  def index
    @pagy, @material_assets = pagy get_scope(params)
  end

  def show
  end

  private
    def base_scope
      MaterialAsset.combined_assets.ordered
    end

    def search_methods
      %i[ name supplier ]
    end

    def set_material_asset
      @material_asset = base_scope.find(params.expect(:id))
    end
end
