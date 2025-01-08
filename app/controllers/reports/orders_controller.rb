class Reports::OrdersController < ApplicationController
  def show
  end

  def create
    @channels = SalesChannel.ordered

    @orders = orders_scope
    @data   = prepare_data @orders
  end

  private
    def orders_scope
      start_date, end_date = calculate_date_range
      Order
        .completed
        .filter_by_preferred_date_in_between(start_date, end_date)
        .report_for_total_orders
    end

    def report_params
      params.expect(report: %i[ trunc_period range_period ])
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
      result.group_by(&:order_month).transform_values do |orders|
        orders.group_by(&:sales_channel_id).transform_values do |rows|
          rows.map do |row|
            { total_sum: row.total_sum, total_tonnage: row.total_tonnage }
          end
        end
      end
    end
end
