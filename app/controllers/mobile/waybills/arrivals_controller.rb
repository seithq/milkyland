module Mobile
  class Waybills::ArrivalsController < MobileController
    before_action :set_waybill, only: %i[ show edit update destroy ]

    def show
    end

    def new
      @waybill = base_scope.new(kind: :arrival)
    end

    def edit
    end

    def create
      @waybill = base_scope.new(waybill_params)

      if @waybill.save
        redirect_on_create edit_waybills_arrival_url(@waybill)
      else
        render_with_error :new, @waybill
      end
    end

    def update
      if @waybill.update(waybill_params)
        ProcessArrivalCodesJob.perform_later @waybill.id if @waybill.approved?
        redirect_on_update waybills_arrival_url(@waybill)
      else
        render_with_error :edit, @waybill
      end
    end

    def destroy
      @waybill.destroy!

      redirect_on_destroy journals_incomings_url
    end

    private
      def base_scope
        Current.user.in_waybills
      end

      def set_waybill
        @waybill = base_scope.find(params.expect(:id))
      end

      def waybill_params
        params.expect(waybill: [ :kind, :storage_id, :new_storage_id, :sender_id, :receiver_id, :status ]).with_defaults(kind: :arrival)
      end
  end
end
