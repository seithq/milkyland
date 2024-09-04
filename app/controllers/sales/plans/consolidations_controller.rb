module Sales
  class Plans::ConsolidationsController < ApplicationController
    include PlanScoped, ReadModes

    before_action :set_consolidation, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @consolidations = base_scope
    end

    def edit
    end

    def update
      if @consolidation.update(consolidation_params)
        redirect_on_update edit_plan_url(@plan)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @consolidation.deactivate

      redirect_on_destroy edit_plan_url(@plan), text: t("actions.order_deactivated")
    end

    private
      def base_scope
        @plan.consolidations.ordered
      end

      def search_methods
        []
      end

      def set_consolidation
        @consolidation = Consolidation.find(params[:id])
      end

      def consolidation_params
        params.require(:consolidation).permit(:active)
      end
  end
end
