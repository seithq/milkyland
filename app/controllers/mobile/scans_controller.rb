class Mobile::ScansController < MobileController
  before_action :set_scan

  def index
  end

  def new
    @frame = params[:frame].presence || "codes"
  end

  private
    def set_scan
      @code = params[:code].presence || ""
      @scan = Scan.find_by @code, allowed_prefixes: (params[:allowed_prefixes].presence || "").split(",")
    end
end
