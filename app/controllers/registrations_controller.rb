class RegistrationsController < ApplicationController
  require_unauthenticated_access

  before_action :verify_join_code

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to root_url
    else
      redirect_to new_session_url(email_address: user_params[:email_address])
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email_address, :password)
    end

    def verify_join_code
      head :not_found if Current.account.join_code != params[:join_code]
    end
end
