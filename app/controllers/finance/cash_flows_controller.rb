class Finance::CashFlowsController < ApplicationController
  def show
  end

  def create
    @trunc_period = cash_flow_params[:trunc_period]
    @start_date, @end_date = calculate_date_range @trunc_period
    @transactions = Transaction.cash_flow @start_date, @end_date, cash_flow_params[:trunc_period]
    @hierarchical_data, @report_periods = generate_cash_flow @transactions
  end

  private
    def cash_flow_params
      params.expect(transaction: %i[ trunc_period year_from year_to ])
    end

    def calculate_date_range(trunc_period)
      case trunc_period
      when "month"
        year_from = Date.new(cash_flow_params[:year_from].to_i, 1, 1)
        [ year_from.beginning_of_year, year_from.end_of_year ]
      when "year"
        year_from = Date.new(cash_flow_params[:year_from].to_i, 1, 1)
        year_to = Date.new(cash_flow_params[:year_to].to_i, 1, 1)
        [ year_from.beginning_of_year, year_to.end_of_year ]
      else
        [ Date.today.beginning_of_month, Date.today.end_of_month ]
      end
    end

    def generate_cash_flow(transactions)
      hierarchical_data = {}
      report_periods = {}

      # Инициализируем структуру данных
      transactions.each_with_object({}) do |row|
        activity_type = row["activity_type"]
        kind = row["kind"]
        financial_category = row["financial_category"]
        article = row["article"]
        report_period = row["report_period"].to_date
        total_amount = row["total_amount"]
        opening_balance = row["opening_balance"]
        closing_balance = row["closing_balance"]

        # Уровень статьи
        hierarchical_data[activity_type] ||= { totals: {}, kinds: {} }
        hierarchical_data[activity_type][:kinds][kind] ||= { totals: {}, categories: {} }
        hierarchical_data[activity_type][:kinds][kind][:categories][financial_category] ||= { totals: {}, articles: {} }
        hierarchical_data[activity_type][:kinds][kind][:categories][financial_category][:articles][article] ||= {}

        hierarchical_data[activity_type][:kinds][kind][:categories][financial_category][:articles][article][report_period] ||= 0
        hierarchical_data[activity_type][:kinds][kind][:categories][financial_category][:articles][article][report_period] += total_amount

        # Итоги для категорий
        hierarchical_data[activity_type][:kinds][kind][:categories][financial_category][:totals][report_period] ||= 0
        hierarchical_data[activity_type][:kinds][kind][:categories][financial_category][:totals][report_period] += total_amount

        # Итоги для kind
        hierarchical_data[activity_type][:kinds][kind][:totals][report_period] ||= 0
        hierarchical_data[activity_type][:kinds][kind][:totals][report_period] += total_amount

        # Итоги для activity_type
        hierarchical_data[activity_type][:totals][report_period] ||= 0
        hierarchical_data[activity_type][:totals][report_period] += total_amount

        # Итоги по всем периодам (для вычисления колонок)
        report_periods[report_period] ||= {}

        report_periods[report_period][:total_amount] ||= 0
        report_periods[report_period][:total_amount] += total_amount

        report_periods[report_period][:opening_balance] ||= opening_balance
        report_periods[report_period][:closing_balance] ||= closing_balance
      end

      [ hierarchical_data, report_periods.sort ]
    end
end
