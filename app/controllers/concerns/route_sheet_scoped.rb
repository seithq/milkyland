module RouteSheetScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_route_sheet
  end

  private
    def set_route_sheet
      @route_sheet = RouteSheet.find(params[:route_sheet_id])
    end
end
