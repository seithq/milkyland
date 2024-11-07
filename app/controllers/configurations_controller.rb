class ConfigurationsController < ApplicationController
  allow_unauthenticated_access

  def android
    render json: {
      settings: {
        screenshots_enabled: true
      },
      rules: [
        {
          patterns: [
            ".*"
          ],
          properties: {
            context: "default",
            uri: "turbo://fragment/web",
            pull_to_refresh_enabled: true
          }
        },
        {
          patterns: %w[^$ ^/$],
          properties: {
            uri: "turbo://fragment/web/home",
            presentation: "replace_root"
          }
        },
        {
          patterns: %w[(?<!(profile|session))/new$ /edit$],
          properties: {
            context: "modal",
            uri: "turbo://fragment/web/modal",
            pull_to_refresh_enabled: false
          }
        }
      ]
    }
  end
end
