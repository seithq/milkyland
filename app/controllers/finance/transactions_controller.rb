class Finance::TransactionsController < ApplicationController
  before_action :set_status, only: :index
  before_action :set_transaction, only: %i[ show edit update destroy ]
  before_action :set_articles, only: %i[ new create edit update ]
  before_action :set_form_vendors, only: %i[ new edit create update show ]
  before_action :set_search_vendors, only: :search

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
      UpdateSupplyOrderPaymentStatusJob.perform_later @transaction.id
      redirect_on_update transactions_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.cancelled!

    redirect_on_destroy transactions_url, text: t("actions.record_cancelled")
  end

  def search
  end

  private
    def base_scope
      scope = Transaction.ordered
      scope = scope.filter_by_status(@status) unless @status == "all"
      scope
    end

    def search_methods
      %i[ kind status client supplier article material_asset amount_from amount_to planned_date_start planned_date_end creator ]
    end

    def set_transaction
      @transaction = Transaction.find(params.expect(:id))
    end

    def transaction_params
      params.expect(transaction: %i[ bank_account_id article_id kind amount status comment planned_date execution_date contragent_id contragent_type material_asset_id ])
    end

    def set_articles
      @kind = @transaction.nil? ? params[:kind].presence || "income" : @transaction.kind
      @articles = Article.filter_by_kind(@kind)
    end

    def set_status
      @status = params[:status].presence || "all"
    end

    def set_form_vendors
      @vendors = @transaction.nil? ? [] : @transaction.material_asset.vendors
    end

    def set_search_vendors
      @vendors = unless params[:material_asset_id].present?
                   []
      else
                   Vendor.where(material_asset_id: params[:material_asset_id])
      end
    end
end
