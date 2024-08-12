class Settings::CategoriesController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update ]
  before_action :set_category, only: %i[ show edit update ]

  def index
    @pagy, @categories = pagy get_scope(params)
  end

  def show
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_on_create categories_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_on_update categories_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def base_scope
      Category.recent_first
    end

    def search_methods
      []
    end

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :kind)
    end
end
