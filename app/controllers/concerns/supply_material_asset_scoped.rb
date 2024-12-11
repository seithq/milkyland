module SupplyMaterialAssetScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_material_asset
  end

  private
    def set_material_asset
      @material_asset = MaterialAsset.find(params[:supply_material_asset_id])
    end
end
