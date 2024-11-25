module PlanScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_plan
  end

  private
    def set_plan
      @plan = Plan.unscoped.find(params[:plan_id])
    end
end
