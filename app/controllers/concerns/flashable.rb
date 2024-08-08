module Flashable
  extend ActiveSupport::Concern

  included do
    def redirect_on_create(url)
      redirect_with_notice url, t("actions.record_created")
    end

    def redirect_on_update(url)
      redirect_with_notice url, t("actions.record_updated")
    end
  end

  private
    def redirect_with_notice(url, notice)
      redirect_to url, notice: notice
    end
end
