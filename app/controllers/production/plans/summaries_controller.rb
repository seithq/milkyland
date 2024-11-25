module Production
  class Plans::SummariesController < ProductionController
    include PlanScoped

    helper_method :card_view?

    def index
      @groups = base_scope
    end

    private
      def base_scope
        scope = @plan.semi? ? @plan.unit_groups : @plan.groups
        scope.ordered.uniq
      end

      def card_view?
        params[:card_view].present? && params[:card_view] == "true"
      end
  end
end
