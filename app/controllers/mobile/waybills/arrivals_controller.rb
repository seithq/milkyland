module Mobile
  class Waybills::ArrivalsController < BaseWaybillsController
    private
      def base_scope
        Current.user.out_waybills
      end

      def waybill_edit_url(waybill)
        edit_waybills_arrival_url(waybill)
      end

      def waybill_show_url(waybill)
        waybills_arrival_url(waybill)
      end

      def waybill_journal_url
        journals_outgoings_url
      end

      def base_kind
        :arrival
      end

      def trigger_processing_job(waybill)
        return unless waybill.approved?
        ProcessArrivalCodesJob.perform_later waybill.id
      end
  end
end
