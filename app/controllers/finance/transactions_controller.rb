class Finance::TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]
  before_action :set_articles, only: %i[ new edit ]

  def index
    @pagy, @transactions = pagy get_scope(params)
  end

  def show
  end

  def new
    @transaction = Transaction.new kind: @kind
  end

  def edit
  end

  def create
    @transaction = Current.user.transactions.new(transaction_params)

    if @transaction.save
      redirect_on_create transactions_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @transaction.update(transaction_params)
      redirect_on_update transactions_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.cancelled!

    redirect_on_destroy transactions_url, text: t("actions.record_cancelled")
  end

  private
    def base_scope
      Transaction.ordered
    end

    def search_methods
      %i[ kind status client article material_asset amount_from amount_to planned_date creator ]
    end

    def set_transaction
      @transaction = base_scope.find(params.expect(:id))
    end

    def transaction_params
      params.expect(transaction: %i[ bank_account_id article_id kind amount status comment planned_date execution_date client_id material_asset_id ])
    end

    def set_articles
      @kind = @transaction.nil? ? params[:kind].presence || "income" : @transaction.kind
      @articles = Article.filter_by_kind(@kind)
    end
end
