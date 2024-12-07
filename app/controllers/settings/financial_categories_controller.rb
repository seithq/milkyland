class Settings::FinancialCategoriesController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update destroy ]
  before_action :set_financial_category, only: %i[ show edit update destroy ]

  def index
    @pagy, @financial_categories = pagy get_scope(params)
  end

  def show
  end

  def new
    @financial_category = base_scope.new
  end

  def edit
  end

  def create
    @financial_category = base_scope.new(financial_category_params)

    if @financial_category.save
      redirect_on_create financial_categories_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @financial_category.update(financial_category_params)
      redirect_on_update financial_categories_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @financial_category.destroy!

    redirect_on_destroy financial_categories_url
  end

  private
    def base_scope
      FinancialCategory.recent_first
    end

    def search_methods
      []
    end

    def set_financial_category
      @financial_category = base_scope.find(params.expect(:id))
    end

    def financial_category_params
      params.expect(financial_category: %i[ kind name ])
    end
end
