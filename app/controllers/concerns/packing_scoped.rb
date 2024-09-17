module PackingScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_packing
  end

  private
    def set_packing
      @packing = Batch.find(params[:batch_id]).packing
    end
end
