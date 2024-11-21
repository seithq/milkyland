class Warehouse::WaybillsController < ApplicationController
  before_action :set_waybill, only: :show

  def index
    @pagy, @waybills = pagy get_scope(params)
  end

  def show
  end

  private
    def base_scope
      Waybill.for_goods.recent_first
    end

    def search_methods
      %i[ start_date end_date kind storage new_storage ]
    end

    def set_waybill
      @waybill = base_scope.find(params.expect(:id))
    end
end
