module Warehouse
  class Storages::ZonesController < ApplicationController
    include StorageScoped

    before_action :set_zone, only: %i[ show edit update destroy ]

    def index
      @pagy, @zones = pagy get_scope(params)
    end

    def show
    end

    def new
      @zone = Zone.new
    end

    def edit
    end

    def create
      @zone = Zone.new(zone_params)
      @zone.index_position = @storage.zones.count

      if @zone.save && @zone.locate_to(@storage)
        redirect_on_create edit_storage_url(@storage)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @zone.update(zone_params)
        redirect_on_update edit_storage_url(@storage)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @zone.deactivate

      redirect_on_destroy storage_zones_url(@storage), text: t("actions.record_deactivated")
    end

    private
      def base_scope
        @storage.zones.ordered
      end

      def set_zone
        @zone = base_scope.find(params.expect(:id))
      end

      def zone_params
        params.expect(zone: %i[ kind active ])
      end
  end
end
