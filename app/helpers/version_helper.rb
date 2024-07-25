module VersionHelper
  def version_badge
    tag.span(Rails.application.config.app_version, class: "")
  end
end
