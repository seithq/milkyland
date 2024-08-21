module PackingMachineScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_packing_machine
  end

  private
    def set_packing_machine
      @packing_machine = PackingMachine.find(params[:packing_machine_id])
    end
end
