module Production::Plans::ProductionUnits
  class Batches::JournalsController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped

    before_action :set_journal, only: :show

    def index
      @journals = base_scope
    end

    def show
    end

    private

    def base_scope
      @batch.production_unit.group.journals
    end

    def set_journal
      @journal = base_scope.find(params[:id])
    end
  end
end
