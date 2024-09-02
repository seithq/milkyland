class Sales::PlansController < ApplicationController
  before_action :set_plan, only: %i[ show edit update destroy ]

  def index
    @plans = Plan.all
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to plan_url(@plan), notice: "Plan was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @plan.cancel

    respond_to do |format|
      format.html { redirect_to plans_url, notice: "Plan was successfully destroyed." }
    end
  end

  private
    def set_plan
      @plan = Plan.find(params[:id])
    end

    def plan_params
      params.require(:plan).permit(:production_date, :status)
    end
end
