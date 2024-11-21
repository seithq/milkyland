module Mobile
  class BaseWaybillsController < MobileController
    before_action :set_waybill, only: %i[ show edit update destroy ]

    def show
    end

    def new
      @waybill = base_scope.new(kind: base_kind)
    end

    def edit
    end

    def create
      @waybill = base_scope.new(waybill_params)

      if @waybill.save
        redirect_on_create waybill_edit_url(@waybill)
      else
        render_with_error :new, @waybill
      end
    end

    def update
      if @waybill.update(waybill_params)
        trigger_processing_job(@waybill) if @waybill.approved?
        redirect_on_update waybill_show_url(@waybill)
      else
        render_with_error :edit, @waybill
      end
    end

    def destroy
      @waybill.destroy!

      redirect_on_destroy waybill_journal_url
    end

    private
      def waybill_edit_url(waybill)
        raise NotImplementedError.new "Implement in subclass"
      end

      def waybill_show_url(waybill)
        raise NotImplementedError.new "Implement in subclass"
      end

      def waybill_journal_url
        raise NotImplementedError.new "Implement in subclass"
      end

      def base_kind
        raise NotImplementedError.new "Implement in subclass"
      end

      def trigger_processing_job(waybill)
        raise NotImplementedError.new "Implement in subclass"
      end

      def set_waybill
        @waybill = Waybill.find(params.expect(:id))
      end

      def waybill_params
        params.expect(waybill: [ :kind, :storage_id, :new_storage_id, :sender_id, :receiver_id, :status ]).with_defaults(kind: base_kind)
      end
  end
end
