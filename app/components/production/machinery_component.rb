class Production::MachineryComponent < ApplicationComponent
  def initialize(machinery:)
    @machinery = machinery
    @plan_performance = @machinery.planning_performance
    @fact_performance = @machinery.performance
  end

  private
    def edit_url
      edit_production_plan_unit_batch_packing_packaged_product_machinery_path(
        @machinery.packaged_product.packing.batch.production_unit.plan,
        @machinery.packaged_product.packing.batch.production_unit,
        @machinery.packaged_product.packing.batch,
        @machinery.packaged_product,
        @machinery
      )
    end

    def icon_class
      passed? ? "bg-green-400/10 text-green-400" : "bg-rose-400/10 text-rose-400"
    end

    def badge_class
      passed? ? "bg-green-400/10 text-green-600 ring-green-400/30" : "bg-rose-400/10 text-rose-600 ring-rose-400/30"
    end

    def passed?
      @fact_performance >= @plan_performance
    end
end
