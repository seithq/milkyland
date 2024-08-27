module ReadModes
  extend ActiveSupport::Concern

  included do
    def set_read_mode
      @readonly = params[:readonly].present? && params[:readonly] == "true"
    end
  end
end
