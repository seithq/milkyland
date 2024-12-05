module Warehouse
  class Storages::SubjectsController < ApplicationController
    include StorageScoped

    def index
      @subjects = base_scope
    end

    private
      def base_scope
        (@storage.for_assets? ? (@storage.material_assets + @storage.semi_products) : @storage.products).uniq
      end
  end
end
