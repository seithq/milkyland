module Authorization
  extend ActiveSupport::Concern

  included do
    rescue_from ActionPolicy::Unauthorized, with: :unauthorized

    def ensure_can_administer
      head :forbidden unless Current.user.can_administer?
    end

    def ensure_current_user
      head :forbidden unless @user.current?
    end
  end

  private
    def unauthorized
      flash[:alert] = t("actions.unauthorized")
      redirect_back fallback_location: root_path
    end
end
