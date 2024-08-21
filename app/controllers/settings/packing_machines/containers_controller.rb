module Settings
  class PackingMachines::ContainersController < ApplicationController
    include PackingMachineScoped, ReadModes

    before_action :ensure_can_administer, only: %i[ create update destroy ]
    before_action :set_container, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @containers = base_scope.recent_first
    end

    def new
      @container = base_scope.new
    end

    def edit
    end

    def create
      @container = base_scope.new(container_params)

      if @container.save
        redirect_on_create edit_packing_machine_url(@packing_machine)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @container.update(container_params)
        redirect_on_update edit_packing_machine_url(@packing_machine)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @container.deactivate

      redirect_on_destroy edit_packing_machine_url(@packing_machine)
    end

    private
      def base_scope
        @packing_machine.containers
      end

      def search_methods
        []
      end

      def set_container
        @container = Container.find(params[:id])
      end

      def container_params
        params.require(:container).permit(:material_asset_id, :performance, :losses_percentage, :active)
      end
  end
end
