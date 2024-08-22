module Flashable
  extend ActiveSupport::Concern

  included do
    def redirect_on_create(url, text: t("actions.record_created"))
      redirect_with_notice url, text
    end

    def redirect_on_update(url, text: t("actions.record_updated"))
      redirect_with_notice url, text
    end

    def redirect_on_destroy(url, text: t("actions.record_deleted"))
      redirect_with_notice url, text
    end
  end

  private
    def redirect_with_notice(url, notice)
      redirect_to url, notice: notice
    end
end
