class Warehouse::WaybillsController < ApplicationController
  before_action :set_waybill, only: %i[ show edit update ]

  def index
    @pagy, @waybills = pagy get_scope(params)
  end

  def show
  end

  def edit
  end

  def update
    if @waybill.update(waybill_params)
      redirect_on_update waybills_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def base_scope
      Waybill.for_goods.recent_first
    end

    def search_methods
      %i[ start_date end_date kind storage new_storage ]
    end

    def set_waybill
      @waybill = Waybill.find(params.expect(:id))
    end

    def waybill_params
      params.expect(waybill: [ :kind, :storage_id, :new_storage_id, :sender_id, :receiver_id, :batch_id, :comment, :active, :manual_approval ])
    end
end
