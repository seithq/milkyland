module Production::Plans::ProductionUnits
  class Batches::JournalsController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped

    before_action :set_journal, only: :show

    def show
    end

    private
      def base_scope
        @batch.journals
      end

      def set_journal
        @journals = base_scope
        @journal  = @journals.find(params[:id])
      end
  end
end
