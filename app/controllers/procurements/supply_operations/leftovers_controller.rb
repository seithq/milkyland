module Procurements
  class SupplyOperations::LeftoversController < ApplicationController
    include SupplyOperationScoped, ReadModes

    before_action :set_leftover, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @leftovers = base_scope.recent_first
    end

    def new
      @leftover = base_scope.new
      @leftover.subject_type = MaterialAsset.model_name.name
    end

    def edit
    end

    def create
      @leftover = base_scope.new(leftover_params)

      if @leftover.save
        redirect_on_create edit_supply_operation_path(@waybill)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @leftover.update(leftover_params)
        redirect_on_update edit_supply_operation_path(@waybill)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @leftover.destroy!

      redirect_on_destroy edit_supply_operation_path(@waybill)
    end

    private
      def base_scope
        @waybill.leftovers.order(id: :asc)
      end

      def search_methods
        []
      end

      def set_leftover
        @leftover = base_scope.find(params.expect(:id))
      end

      def leftover_params
        params.expect(leftover: %i[ storage_id subject_id subject_type count ])
      end
  end
end
