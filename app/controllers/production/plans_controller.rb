class Production::PlansController < ProductionController
  before_action :set_status
  before_action :set_plan, only: %i[ show edit update ]

  helper_method :should_cancel?

  def index
    @plans = get_scope(params)
  end

  def show
  end

  def edit
  end

  def update
    if @plan.update(plan_params)
      redirect_on_update production_plan_path(@plan)
    else
      render :edit, status: :unprocessable_entity
    end
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
      params.require(:plan).permit(:status, :comment)
    end

    def set_status
      @status = params[:status].presence || "active"
    end

    def should_cancel?
      params[:cancel].present? && params[:cancel] == "true"
    end
end
