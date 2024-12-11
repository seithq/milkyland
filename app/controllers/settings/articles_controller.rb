class Settings::ArticlesController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update destroy ]
  before_action :set_article, only: %i[ show edit update destroy ]
  before_action :set_financial_categories, only: %i[ new create edit update ]

  def index
    @pagy, @articles = pagy get_scope(params)
  end

  def show
  end

  def new
    @article = base_scope.new(kind: @kind)
  end

  def edit
  end

  def create
    @article = base_scope.new(article_params)

    if @article.save
      redirect_on_create articles_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      redirect_on_update articles_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy!

    redirect_on_destroy articles_url
  end

  private
    def base_scope
      Article.recent_first
    end

    def search_methods
      []
    end

    def set_article
      @article = base_scope.find(params.expect(:id))
    end

    def article_params
      params.expect(article: %i[ financial_category_id activity_type_id name kind min_amount bypass_control system suppliable ])
    end

    def set_financial_categories
      @kind = @article.nil? ? params[:kind].presence || "income" : @article.kind
      @financial_categories = FinancialCategory.filter_by_kind(@kind)
    end
end
