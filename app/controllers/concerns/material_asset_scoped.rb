module MaterialAssetScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_material_asset
  end

  private
    def set_material_asset
      @material_asset = MaterialAsset.find(params[:material_asset_id])
    end
end
