class Settings::ActivityTypesController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update destroy ]
  before_action :set_activity_type, only: %i[ show edit update destroy ]

  def index
    @pagy, @activity_types = pagy get_scope(params)
  end

  def show
  end

  def new
    @activity_type = base_scope.new
  end

  def edit
  end

  def create
    @activity_type = base_scope.new(activity_type_params)

    if @activity_type.save
      redirect_on_create activity_types_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @activity_type.update(activity_type_params)
      redirect_on_update activity_types_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @activity_type.destroy!

    redirect_on_destroy activity_types_url
  end

  private
    def base_scope
      ActivityType.recent_first
    end

    def search_methods
      []
    end

    def set_activity_type
      @activity_type = base_scope.find(params.expect(:id))
    end

    def activity_type_params
      params.expect(activity_type: %i[ name order_number ])
    end
end
