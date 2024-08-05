module VersionHelper
  def version_badge
    tag.span(t("pages.version", version: Rails.application.config.app_version), class: "version-badge")
  end
end
