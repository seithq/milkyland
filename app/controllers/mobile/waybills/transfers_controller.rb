module Mobile
  class Waybills::TransfersController < BaseWaybillsController
    before_action :set_receivers, only: %i[ edit update ]

    private
      def base_scope
        Current.user.out_waybills
      end

      def waybill_edit_url(waybill)
        edit_waybills_transfer_url(waybill)
      end

      def waybill_show_url(waybill)
        waybills_transfer_url(waybill)
      end

      def waybill_journal_url
        journals_outgoings_url
      end

      def base_kind
        :transfer
      end

      def trigger_processing_job(waybill)
        return unless waybill.approved?
        ProcessTransferCodesJob.perform_later waybill.id
      end

      def set_receivers
        @receivers = @waybill.new_storage.warehousers.recent_first
      end
  end
end
