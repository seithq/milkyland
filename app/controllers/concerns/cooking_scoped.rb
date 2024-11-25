module CookingScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_cooking
  end

  private
    def set_cooking
      @cooking = Batch.find(params[:batch_id]).cooking
    end
end
