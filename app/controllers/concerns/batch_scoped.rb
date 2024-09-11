module BatchScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_batch
  end

  private
    def set_batch
      @batch = Batch.find(params[:batch_id])
    end
end
