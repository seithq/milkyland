module Settings
  class Groups::OperationsController < ApplicationController
    include GroupScoped, ReadModes

    before_action :ensure_can_administer, only: %i[ create update destroy ]
    before_action :set_operation, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @operations = base_scope.recent_first
    end

    def new
      @operation = base_scope.new
    end

    def edit
    end

    def create
      @operation = base_scope.new(operation_params)

      if @operation.save
        redirect_on_create edit_group_path(@group)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @operation.update(operation_params)
        redirect_on_update edit_group_path(@group)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @operation.deactivate

      redirect_on_destroy edit_group_path(@group)
    end

    private
      def base_scope
        @group.operations
      end

      def search_methods
        []
      end

      def set_operation
        @operation = base_scope.find(params[:id])
      end

      def operation_params
        params.require(:operation).permit(:journal_id, :name, :chain_order, :active)
      end
  end
end
