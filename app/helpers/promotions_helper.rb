module PromotionsHelper
  def promotion_status(promo)
    tag.span class: status_color(promo) do
      status_label promo
    end
  end

  private
    def status_color(promo)
      if promo.active?
        promo.running? ? "text-green-600" : "text-yellow-600"
      else
        "text-red-600"
      end
    end

    def status_label(promo)
      if promo.active?
        promo.running? ? t("forms.promo_running") : t("forms.promo_ended")
      else
        t("forms.promo_deactivated")
      end
    end
end
