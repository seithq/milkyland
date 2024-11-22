module Warehouse
  class Storages::WarehousersController < ApplicationController
    include StorageScoped, ReadModes

    before_action :set_warehouser, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @pagy, @warehousers = pagy get_scope(params)
    end

    def new
      @warehouser = base_scope.new
    end

    def edit
    end

    def create
      @warehouser = base_scope.new(warehouser_params)

      if @warehouser.save
        redirect_on_create edit_storage_url(@storage)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @warehouser.update(warehouser_params)
        redirect_on_update edit_storage_url(@storage)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @warehouser.deactivate

      redirect_on_destroy edit_storage_url(@storage), text: t("actions.record_deactivated")
    end

    def search
      @warehousers = base_scope
    end

    private
      def base_scope
        @storage.warehousers.recent_first
      end

      def set_warehouser
        @warehouser = base_scope.find(params.expect(:id))
      end

      def warehouser_params
        params.expect(warehouser: %i[ user_id active duty replaceable_id ])
      end
  end
end
