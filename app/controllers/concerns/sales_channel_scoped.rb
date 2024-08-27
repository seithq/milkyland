module SalesChannelScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_sales_channel_and_status
  end

  private
    def set_sales_channel_and_status
      @sales_channel = SalesChannel.find(params[:sales_channel_id])
      @status = params[:status].presence || "in_planning"
    end
end
