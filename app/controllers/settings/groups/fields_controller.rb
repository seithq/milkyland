module Settings
  class Groups::FieldsController < ApplicationController
    include GroupScoped, ReadModes

    before_action :ensure_can_administer, only: %i[ create update destroy ]
    before_action :set_field, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @fields = base_scope.recent_first
    end

    def new
      @field = Field.new
    end

    def edit
    end

    def create
      @field = Field.new(field_params)

      if @field.save
        redirect_on_create edit_group_path(@group)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @field.update(field_params)
        redirect_on_update edit_group_path(@group)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @field.deactivate

      redirect_on_destroy edit_group_path(@group)
    end

    private
      def base_scope
        @group.fields
      end

      def search_methods
        []
      end

      def set_field
        @field = base_scope.find(params[:id])
      end

      def field_params
        params.require(:field).permit(:operation_id, :name, :chain_order, :kind, :active, :measurement_id, :standard_id)
      end
  end
end
