class Production::PlansController < ProductionController
  before_action :set_status
  before_action :set_plan, only: %i[ show edit update destroy ]

  def index
    @plans = get_scope(params)
  end

  def show
  end

  def edit
  end

  def update
    if @plan.update(plan_params)
      redirect_to plan_url(@plan)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plan.cancel comment: ""

    redirect_to plans_url
  end

  private
    def base_scope
      Plan.send(@status).order(production_date: :asc)
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
      @status = params[:status].presence || "active"
    end
end
