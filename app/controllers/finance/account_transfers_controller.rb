class Finance::AccountTransfersController < ApplicationController
  before_action :set_system_articles

  def new
  end

  def create
    expense_trx, income_trx = Transaction.transfer Current.user.id,
                                                   transaction_params[:source_account_id],
                                                   transaction_params[:destination_account_id],
                                                   transaction_params[:amount],
                                                   @source_article.id,
                                                   @destination_article.id

    if expense_trx && income_trx
      redirect_on_create transactions_url
    else
      flash.now[:alert] = t("actions.failed_account_transfer")
      render :new, status: :unprocessable_entity
    end
  end

  private
    def transaction_params
      params.expect(transaction: %i[ source_account_id destination_account_id amount ])
    end

    def set_system_articles
      alert = ""

      source_articles = Article.systems(:expense)
      alert = t("actions.create_expense_system") if source_articles.count.zero?

      destination_articles = Article.systems(:income)
      alert = t("actions.create_income_system") if destination_articles.count.zero?

      unless alert.blank?
        redirect_with_alert(transactions_url, alert) and return
      end

      @source_article, @destination_article = source_articles.first, destination_articles.first
    end
end
