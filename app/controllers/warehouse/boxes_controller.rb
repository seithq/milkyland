class Warehouse::BoxesController < ApplicationController
  include PositionableScoped

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

    def positionable_scope
      @positionable.all_boxes.recent_first
    end
end
