class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { render_rejection :too_many_requests }

  before_action :ensure_user_exists, only: :new

  def new
    redirect_to main_url if signed_in?
  end

  def create
    if (user = User.active.authenticate_by(authentication_params))
      start_new_session_for user
      redirect_to post_authenticating_url
    else
      render_rejection :unauthorized
    end
  end

  def destroy
    reset_authentication
    redirect_to new_session_url
  end

  private
    def authentication_params
      params.permit(:email_address, :password)
    end

    def ensure_user_exists
      redirect_to first_run_url if User.none?
    end

    def render_rejection(status)
      flash[:alert] = t("alerts.too_many_requests_or_unauthorized")
      render :new, status: status
    end
end
