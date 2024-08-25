module ChannelScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_channel_and_status
  end

  private
    def set_channel_and_status
      @channel = SalesChannel.find(params[:channel_id])
      @status  = params[:status].presence || "in_planning"
    end
end
