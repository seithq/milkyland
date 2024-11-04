module ZoneScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_zone
  end

  private
    def set_zone
      @zone = Zone.find(params[:zone_id])
    end
end
