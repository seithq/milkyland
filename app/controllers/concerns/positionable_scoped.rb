module PositionableScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_positionable, only: :location

    def location
      @pagy, @elements = pagy positionable_scope
    end

    private
      def set_positionable
        @positionable = params.expect(:positionable_type).constantize.find(params.expect(:positionable_id))
      end

      def positionable_scope
        raise NotImplementedError.new "Implement in subclass"
      end
  end
end
