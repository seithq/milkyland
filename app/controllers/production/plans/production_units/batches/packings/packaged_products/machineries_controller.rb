module Production::Plans::ProductionUnits::Batches::Packings
  class PackagedProducts::MachineriesController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped, PackingScoped, PackagedProductScoped

    before_action :set_machinery, only: %i[ edit update destroy ]
    before_action :set_packing_material_assets, only: :search

    def index
      @machineries = base_scope
    end

    def new
      @machinery = base_scope.new
    end

    def edit
    end

    def create
      @machinery = base_scope.new(machinery_params)

      if @machinery.save
        redirect_on_create edit_production_plan_unit_batch_packing_packaged_product_url(@plan, @production_unit, @batch, @packaged_product)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @machinery.update(machinery_params)
        redirect_on_create edit_production_plan_unit_batch_packing_packaged_product_url(@plan, @production_unit, @batch, @packaged_product)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @machinery.destroy!

      redirect_on_create edit_production_plan_unit_batch_packing_packaged_product_url(@plan, @production_unit, @batch, @packaged_product)
    end

    def search
    end

    private
      def base_scope
        @packaged_product.machineries
      end

      def set_machinery
        @machinery = base_scope.find(params.expect(:id))
      end

      def machinery_params
        params.expect(machinery: %i[ packing_machine_id material_asset_id start_time end_time count ])
      end

      def set_packing_material_assets
        @packing_material_assets = []

        return unless params.has_key?(:packing_machine_id)

        containers = Container.where packing_machine_id: params[:packing_machine_id]
        return if containers.empty?

        @packing_material_assets = MaterialAsset.where(id: containers.pluck(:material_asset_id))
      end
  end
end
