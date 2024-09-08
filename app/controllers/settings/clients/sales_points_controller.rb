module Settings
  class Clients::SalesPointsController < ApplicationController
    include ClientScoped, ReadModes

    before_action :ensure_can_administer, only: %i[ create update destroy ]
    before_action :set_sales_point, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @sales_points = base_scope.recent_first
    end

    def new
      @sales_point = base_scope.new
    end

    def edit
    end

    def create
      @sales_point = base_scope.new(sales_point_params)

      if @sales_point.save
        redirect_on_create edit_client_path(@client)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @sales_point.update(sales_point_params)
        redirect_on_update edit_client_path(@client)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @sales_point.deactivate

      redirect_on_destroy edit_client_path(@client)
    end

    private
      def base_scope
        @client.sales_points
      end

      def search_methods
        []
      end

      def set_sales_point
        @sales_point = base_scope.find(params[:id])
      end

      def sales_point_params
        params.require(:sales_point).permit(:region_id, :name, :address, :phone_number, :active)
      end
  end
end
