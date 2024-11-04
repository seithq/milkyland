module LineScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_line
  end

  private
    def set_line
      @line = Line.find(params[:line_id])
    end
end
