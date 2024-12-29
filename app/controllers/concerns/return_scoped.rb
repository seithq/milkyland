module ReturnScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_return
  end

  private
    def set_return
      @return = Return.find(params[:return_id])
    end
end
