module Production
  class Plans::SummariesController < ApplicationController
    include PlanScoped

    helper_method :card_view?

    def index
      @groups = base_scope
    end

    private
      def base_scope
        @plan.groups.ordered.uniq
      end

      def card_view?
        params[:card_view].present? && params[:card_view] == "true"
      end
  end
end
