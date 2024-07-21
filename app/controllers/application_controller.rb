class ApplicationController < ActionController::Base
  # TODO: move to authentication module
  protect_from_forgery

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
