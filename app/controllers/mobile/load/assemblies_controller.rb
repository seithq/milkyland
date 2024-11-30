module Mobile
  class Load::AssembliesController < MobileController
    before_action :set_assembly, only: %i[ show edit update destroy ]

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
      @assembly = base_scope.new(assembly_params)

      if @assembly.save
        redirect_on_update edit_load_assembly_url(@assembly)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @assembly.update(assembly_params)
        redirect_on_update load_assembly_url(@assembly)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @assembly.destroy!

      redirect_on_destroy load_assemblies_url
    end

    private
      def base_scope
        Current.user.assemblies.recent_first
      end

      def set_assembly
        @assembly = base_scope.find(params.expect(:id))
      end

      def assembly_params
        params.expect(assembly: %i[ route_sheet_id zone_id status ])
      end
  end
end
