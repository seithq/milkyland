module StorageScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_storage
  end

  private
    def set_storage
      @storage = Storage.find(params[:storage_id])
    end
end
