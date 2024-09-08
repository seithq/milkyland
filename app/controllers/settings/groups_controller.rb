class Settings::GroupsController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update ]
  before_action :set_group, only: %i[ show edit update ]

  def index
    @pagy, @groups = pagy get_scope(params)
  end

  def show
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_on_create edit_group_url(@group)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @group.update(group_params)
      redirect_on_update groups_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def base_scope
      Group.recent_first
    end

    def search_methods
      []
    end

    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :metric_tonne, :category_id, :cooking_technology)
    end
end
