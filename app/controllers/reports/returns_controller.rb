class Reports::ReturnsController < ApplicationController
  def show
  end

  def create
    @orders = orders_scope
    @data   = prepare_data @orders

    puts "="*80
    puts @data.to_json
    puts "="*80
  end

  private
    def orders_scope
      start_date, end_date = calculate_date_range
      base_scope = Order.completed.filter_by_preferred_date_in_between(start_date, end_date)
      if report_params[:group_id].present?
        base_scope = base_scope.filter_by_group(report_params[:group_id])
      end
      if report_params[:product_id].present?
        base_scope = base_scope.filter_by_product(report_params[:product_id])
      end
      base_scope.report_for_returns
    end

    def report_params
      params.expect(report: %i[ trunc_period range_period group_id product_id ])
    end

    def calculate_date_range
      date = Date.new(
        report_params["range_period(1i)"].to_i,
        report_params["range_period(2i)"].to_i,
        report_params["range_period(3i)"].to_i
      )

      case report_params[:trunc_period]
      when "year"
        [ date.beginning_of_year, date.end_of_year ]
      else
        [ date.beginning_of_month, date.end_of_month ]
      end
    end

    def prepare_data(result)
      start_date, end_date = calculate_date_range
      @all_months = (start_date..end_date).select { |date| date.day == 1 }.map { |date| date.strftime("%Y-%m-%d") }

      result.group_by { |row| "#{ row[:group_id] }@#{ row[:group_name] }" }.transform_values do |groups|
        groups.group_by { |row| "#{ row[:product_id] }@#{ row[:product_name] }" }.transform_values do |orders|
          # Сопоставляем данные с полным списком месяцев
          orders_by_month = orders.index_by { |row| row.order_month.strftime("%Y-%m-%d") }
          @all_months.each_with_object({}) do |month, memo|
            if orders_by_month[month]
              row = orders_by_month[month]
              memo[month] = {
                total_count: row.total_count,
                total_tonnage: row.total_tonnage,
                return_total_count: row.return_total_count,
                return_total_tonnage: row.return_total_tonnage
              }
            else
              # Заполняем нулями, если данных за месяц нет
              memo[month] = { total_count: 0, total_tonnage: 0.0, return_total_count: 0, return_total_tonnage: 0.0 }
            end
          end
        end
      end
    end
end
