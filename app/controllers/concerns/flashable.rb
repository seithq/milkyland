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

    def render_with_error(view, resource)
      flash.now[:alert] = resource.errors.full_messages.to_sentence
      render view, status: :unprocessable_entity
    end

    def redirect_with_error(url, resource)
      redirect_with_alert url, resource.errors.full_messages.to_sentence
    end
  end

  private
    def redirect_with_notice(url, notice)
      redirect_to url, notice: notice
    end

    def redirect_with_alert(url, alert)
      redirect_to url, alert: alert
    end
end
