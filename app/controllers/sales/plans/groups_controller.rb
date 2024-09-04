module Sales
  class Plans::GroupsController < ApplicationController
    include PlanScoped

    def index
      @groups = base_scope
    end

    private
      def base_scope
        @plan.groups.ordered.uniq
      end

      def search_methods
        []
      end
  end
end
