module TurboNativeHelper
  def page_title
    if turbo_native_app?
      content_for(:turbo_native_title) || content_for(:title) || t("pages.base_title")
    else
      content_for(:title) || t("pages.base_title")
    end
  end

  def platform_identifier
    if turbo_native_app?
      "turbo-native"
    else
      "web"
    end
  end
end
