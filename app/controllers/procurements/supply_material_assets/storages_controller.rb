module Procurements
  class SupplyMaterialAssets::StoragesController < ApplicationController
    include MaterialAssetScoped, ReadModes

    before_action :set_read_mode, only: :index

    def index
      @storages = base_scope
    end

    private
      def base_scope
        @material_asset.storages.uniq
      end

      def search_methods
        []
      end
  end
end
