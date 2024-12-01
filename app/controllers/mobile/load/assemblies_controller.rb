module Mobile
  class Load::AssembliesController < MobileController
    before_action :set_assembly, only: %i[ show edit update destroy ]
    before_action :set_zones, only: %i[ new edit ]

    def index
      @pagy, @assemblies = pagy_countless get_scope(params)
    end

    def show
    end

    def new
      @assembly = base_scope.new
    end

    def edit
    end

    def create
      @assembly = Assembly.new(assembly_params)
      @assembly.user = Current.user

      if @assembly.save
        redirect_on_create edit_load_assembly_url(@assembly)
      else
        render_with_error :new, @assembly
      end
    end

    def update
      if @assembly.update(assembly_params)
        trigger_processing_job(@assembly)
        redirect_on_update load_assembly_url(@assembly)
      else
        redirect_with_error edit_load_assembly_url(@assembly), @assembly
      end
    end

    def destroy
      @assembly.destroy!

      redirect_on_destroy load_assemblies_url
    end

    private
      def base_scope
        authorized_scope(Assembly.all).recent_first
      end

      def set_assembly
        @assembly = base_scope.find(params.expect(:id))
      end

      def assembly_params
        params.expect(assembly: %i[ route_sheet_id zone_id status ])
      end

      def set_zones
        @zones = authorized_scope(Zone.all, type: :relation, as: :mobile).ordered
      end

      def trigger_processing_job(assembly)
        return unless assembly.approved?

        ProcessAssemblyCodesJob.perform_later assembly.id
      end
  end
end
