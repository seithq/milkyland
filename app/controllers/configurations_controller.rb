class ConfigurationsController < ApplicationController
  allow_unauthenticated_access

  def android
    render json: {
      settings: {},
      rules: [
        {
          patterns: [
            ".*"
          ],
          properties: {
            context: "default",
            uri: "hotwire://fragment/web",
            fallback_uri: "hotwire://fragment/web",
            pull_to_refresh_enabled: true
          }
        },
        {
          patterns: %w[^feed$ ^feed/$],
          properties: {
            uri: "hotwire://fragment/web/home",
            presentation: "replace_root"
          }
        },
        {
          patterns: %w[(?<!(session))/new$ /edit$],
          properties: {
            context: "modal",
            uri: "hotwire://fragment/web/modal/sheet",
            pull_to_refresh_enabled: false
          }
        }
      ]
    }
  end
end
