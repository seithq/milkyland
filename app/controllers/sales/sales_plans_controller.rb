class Sales::SalesPlansController < ApplicationController
  before_action :set_sales_plan, only: %i[ show edit update destroy ]

  def index
    @pagy, @sales_plans = pagy get_scope(params)
    authorize!
  end

  def show
    @channels = SalesChannel.ordered
    @groups   = Group.end_products.includes(:products)
  end

  def new
    @sales_plan = SalesPlan.new
    authorize! @sales_plan
  end

  def edit
    @channels = SalesChannel.ordered
    @groups   = Group.end_products.includes(:products)
  end

  def create
    @sales_plan = SalesPlan.new(sales_plan_params)
    authorize! @sales_plan

    if @sales_plan.save
      redirect_on_create edit_sales_plan_url(@sales_plan)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    update_sales_plan_params[:estimations].each do |estimation|
      @sales_plan.estimations.find_or_initialize_by(
        sales_channel_id: estimation[:sales_channel_id],
        product_id: estimation[:product_id]
      ).update! planned_count: estimation[:planned_count]
    end

    redirect_on_update edit_sales_plan_url(@sales_plan)
  end

  def destroy
    @sales_plan.destroy

    redirect_on_destroy sales_plans_url
  end

  private
    def base_scope
      SalesPlan.ordered
    end

    def search_methods
      [ :region ]
    end

    def set_sales_plan
      @sales_plan = SalesPlan.find(params.expect(:id))
      authorize! @sales_plan
    end

    def sales_plan_params
      params.expect(sales_plan: %i[ region_id month ])
    end

    def update_sales_plan_params
      params.expect(sales_plan: [ { estimations: [ %i[ product_id sales_channel_id planned_count ] ] } ])
    end
end
