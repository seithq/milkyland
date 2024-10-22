class ApplicationController < ActionController::Base
  include Authentication, Authorization, PageLayouts, Searchable, VersionHeaders, Flashable
  include Pagy::Backend, Zipline

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: { safari: 16.4, chrome: 120, firefox: 121, opera: 106, ie: false }
end
