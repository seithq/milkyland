class Mobile::ScansController < MobileController
  before_action :set_scan

  def index
  end

  private
    def set_scan
      @code = params[:code].presence || ""
      @scan = Scan.find_by @code
    end
end
