module Mobile
  class Waybills::WriteOffsController < BaseWaybillsController
    private
      def base_scope
        Current.user.out_waybills
      end

      def waybill_edit_url(waybill)
        edit_waybills_write_off_url(waybill)
      end

      def waybill_show_url(waybill)
        waybills_write_off_url(waybill)
      end

      def waybill_journal_url
        journals_outgoings_url
      end

      def base_kind
        :write_off
      end

      def trigger_processing_job(waybill)
        return unless waybill.approved?
        ProcessWriteOffCodesJob.perform_later waybill.id
      end
  end
end
