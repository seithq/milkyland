class Sales::PlansController < ApplicationController
  before_action :set_status
  before_action :set_plan, only: %i[ show edit update destroy ]

  def index
    @pagy, @plans = pagy get_scope(params)
  end

  def show
  end

  def edit
  end

  def update
    if @plan.update(plan_params)
      redirect_on_update plans_url(status: @plan.status)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plan.cancel

    redirect_on_destroy plan_url, text: t("actions.plan_cancelled")
  end

  private
    def base_scope
      Plan.filter_by_status(@status).ordered
    end

    def search_methods
      []
    end

    def set_plan
      @plan = Plan.find(params[:id])
    end

    def plan_params
      params.require(:plan).permit(:status)
    end

    def set_status
      @status = params[:status].presence || "in_consolidation"
    end
end
