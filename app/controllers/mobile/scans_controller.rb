class Mobile::ScansController < MobileController
  before_action :set_scan
  before_action :set_preview_options, only: :new

  def index
  end

  def new
  end

  private
    def set_scan
      @code = params[:code].presence || ""
      @scan = Scan.find_by @code, allowed_prefixes: get_allowed_prefixes
    end

    def set_preview_options
      @frame = params[:frame].presence || "location_storable_codes"
      @input_name = params[:input_name].presence || "location[storable_codes][]"
      @turbo_action_name = params[:action_name].presence || "prepend"
      @input_value = params[:input_value].presence || "code"
    end

    def get_allowed_prefixes
      (params[:allowed_prefixes].presence || "").split(",")
    end
end
