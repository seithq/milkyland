module Warehouse
  class Waybills::LeftoversController < ApplicationController
    include WaybillScoped

    def index
      @leftovers = base_scope.recent_first
    end

    private
      def base_scope
        @waybill.leftovers.order(id: :asc)
      end
  end
end
