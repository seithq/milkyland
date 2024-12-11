class Settings::BankAccountsController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update destroy ]
  before_action :set_bank_account, only: %i[ show edit update destroy ]

  def index
    @pagy, @bank_accounts = pagy get_scope(params)
  end

  def show
  end

  def new
    @bank_account = base_scope.new
  end

  def edit
  end

  def create
    @bank_account = base_scope.new(bank_account_params)

    if @bank_account.save
      redirect_on_create bank_accounts_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @bank_account.update(bank_account_params)
      redirect_on_update bank_accounts_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bank_account.destroy!

    redirect_on_destroy bank_accounts_url
  end

  private
    def base_scope
      BankAccount.recent_first
    end

    def search_methods
      []
    end

    def set_bank_account
      @bank_account = base_scope.find(params.expect(:id))
    end

    def bank_account_params
      params.expect(bank_account: %i[ company_id name number main ])
    end
end
