class Warehouse::BoxesController < ApplicationController
  before_action :set_box, only: :show

  def index
    @pagy, @boxes = pagy get_scope(params)
  end

  def show
  end

  private
    def base_scope
      Box.recent_first
    end

    def search_methods
      %i[ code region address ]
    end

    def set_box
      @box = base_scope.find(params.expect(:id))
    end
end
