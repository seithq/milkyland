class Settings::RegionsController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update ]
  before_action :set_region, only: %i[ show edit update ]

  def index
    @pagy, @regions = pagy get_scope(params)
  end

  def show
  end

  def new
    @region = Region.new
  end

  def edit
  end

  def create
    @region = Region.new(region_params)

    if @region.save
      redirect_on_create regions_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @region.update(region_params)
      redirect_on_update regions_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def base_scope
      Region.ordered
    end

    def search_methods
      []
    end

    def set_region
      @region = Region.find(params[:id])
    end

    def region_params
      params.require(:region).permit(:name, :code)
    end
end
