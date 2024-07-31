class UsersController < ApplicationController
  before_action :ensure_can_administer, only: %i[ edit update destroy ]
  before_action :set_user, only: %i[ edit update destroy ]

  def index
    @users = get_scope params
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.create(user_params)
    if @user.save
      redirect_to users_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to users_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.deactivate
    redirect_to users_url
  end

  private
    def base_scope
      User.recent_first
    end

    def search_methods
      %i[ name_or_email ]
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email_address, :password, :role, :active)
    end
end
