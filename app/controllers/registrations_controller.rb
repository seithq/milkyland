class RegistrationsController < ApplicationController
  require_unauthenticated_access

  before_action :verify_join_code

  def new
    @user = User.new
  end

  def create
    @user = User.create!(user_params)
    start_new_session_for @user
    redirect_to root_url
  rescue ActiveRecord::RecordNotUnique
    redirect_to new_session_url(email_address: user_params[:email_address])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email_address, :password)
  end

  def verify_join_code
    head :not_found if Current.account.join_code != params[:join_code]
  end
end
