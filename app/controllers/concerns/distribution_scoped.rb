module DistributionScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_distribution
  end

  private
    def set_distribution
      @distribution = Batch.find(params[:batch_id]).distribution
    end
end
