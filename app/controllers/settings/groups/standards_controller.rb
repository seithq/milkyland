module Settings
  class Groups::StandardsController < ApplicationController
    include GroupScoped, ReadModes

    before_action :ensure_can_administer, only: %i[ create update destroy ]
    before_action :set_standard, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @standards = base_scope.recent_first
    end

    def new
      @standard = base_scope.new
    end

    def edit
    end

    def create
      @standard = base_scope.new(standard_params)

      if @standard.save
        redirect_on_create edit_group_url(@group)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @standard.update(standard_params)
        redirect_on_update edit_group_url(@group)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @standard.deactivate

      redirect_on_destroy edit_group_url(@group)
    end

    private
      def base_scope
        @group.standards
      end

      def search_methods
        []
      end

      def set_standard
        @standard = Standard.find(params[:id])
      end

      def standard_params
        params.require(:standard).permit(:measurement_id, :name, :from, :to, :active)
      end
  end
end
