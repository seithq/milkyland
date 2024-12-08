class Settings::CompaniesController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update destroy ]
  before_action :set_company, only: %i[ show edit update destroy ]

  def index
    @pagy, @companies = pagy get_scope(params)
  end

  def show
  end

  def new
    @company = base_scope.new
  end

  def edit
  end

  def create
    @company = base_scope.new(company_params)

    if @company.save
      redirect_on_create companies_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @company.update(company_params)
      redirect_on_update companies_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @company.destroy!

    redirect_on_destroy companies_url
  end

  private
    def base_scope
      Company.recent_first
    end

    def search_methods
      []
    end

    def set_company
      @company = base_scope.find(params.expect(:id))
    end

    def company_params
      params.expect(company: %i[ name ])
    end
end
