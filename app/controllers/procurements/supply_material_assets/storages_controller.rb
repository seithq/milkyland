module Procurements
  class SupplyMaterialAssets::StoragesController < ApplicationController
    include SupplyMaterialAssetScoped

    def index
      @storages = base_scope
    end

    private
      def base_scope
        @material_asset.storages.uniq
      end
  end
end
