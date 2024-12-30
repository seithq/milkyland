module Mobile
  class Journals::OutgoingsController < MobileController
    def index
      @pagy, @waybills = pagy_countless get_scope(params)
    end

    private
      def base_scope
        @waybills = Current.user.out_waybills.without_return_back.for_goods.recent_first
      end
  end
end
