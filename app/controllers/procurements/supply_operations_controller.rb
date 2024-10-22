class Procurements::SupplyOperationsController < ApplicationController
  before_action :set_waybill, only: %i[ show edit update destroy ]

  def index
    @pagy, @waybills = pagy get_scope(params)
  end

  def show
  end

  def new
    @waybill = base_scope.new
    @waybill.sender_id = Current.user.id
  end

  def edit
  end

  def create
    @waybill = base_scope.new(waybill_params)

    if @waybill.save
      redirect_on_create edit_supply_operation_url(@waybill)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @waybill.update(waybill_params)
      redirect_on_update supply_operations_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @waybill.deactivate

    redirect_on_destroy supply_operations_url, text: t("actions.record_deactivated")
  end

  private
    def base_scope
      # Waybill.for_material_assets.recent_first
      Waybill.recent_first
    end

    def search_methods
      %i[ start_date end_date kind ]
    end

    def set_waybill
      @waybill = base_scope.find(params.expect(:id))
    end

    def waybill_params
      params.expect(waybill: [ :kind, :storage_id, :new_storage_id, :sender_id, :receiver_id, :batch_id, :comment, :active ])
    end
end
