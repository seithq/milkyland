class Production::PlansController < ProductionController
  before_action :set_status
  before_action :set_kind, only: %i[ index new ]
  before_action :set_plan, only: %i[ show edit update ]

  def index
    @plans = get_scope(params)
  end

  def show
  end

  def new
    @plan = Plan.new(kind: @kind, status: :ready_to_production)
    @plan.units.build
  end

  def create
    @plan = Plan.new(plan_params)

    if @plan.save
      redirect_on_create production_plan_url(@plan)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @plan.update(plan_params)
      post_update_hook @plan
      redirect_on_update production_plan_url(@plan)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def base_scope
      direction = @status == "active" ? :asc : :desc
      Plan.send(@status).filter_by_kind(@kind).order(production_date: direction)
    end

    def search_methods
      []
    end

    def set_plan
      @plan = Plan.find(params[:id])
    end

    def plan_params
      params.require(:plan).permit(:status, :comment, :kind, :production_date, units_attributes: %i[ id plan_id group_id count tonnage ])
    end

    def set_status
      @status = params[:status].presence || "active"
    end

    def set_kind
      @kind = params[:kind].presence || "standard"
    end

  def post_update_hook(plan)
    return unless plan.produced?

    ShipmentGenerationJob.perform_later plan.id
  end
end
