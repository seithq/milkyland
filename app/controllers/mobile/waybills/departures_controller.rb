module Mobile
  class Waybills::DeparturesController < BaseWaybillsController
    def new
      super
      @waybill.collectable = true
    end

    private
      def base_scope
        Current.user.out_waybills
      end

      def waybill_edit_url(waybill)
        edit_waybills_departure_url(waybill)
      end

      def waybill_show_url(waybill)
        waybills_departure_url(waybill)
      end

      def waybill_journal_url
        journals_outgoings_url
      end

      def base_kind
        :departure
      end

      def trigger_processing_job(waybill)
        return unless waybill.approved?
        ProcessDepartureCodesJob.perform_later waybill.id
      end
  end
end
