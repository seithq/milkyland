module AssemblyScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_assembly
  end

  private
    def set_assembly
      @assembly = Assembly.find(params[:assembly_id])
    end
end
