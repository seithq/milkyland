module Warehouse
  class Storages::WaybillsController < ApplicationController
    include StorageScoped

    def index
      @pagy, @waybills = pagy get_scope(params)
    end

    private
      def base_scope
        Waybill.filter_by_both_storage(@storage).recent_first
      end
  end
end
