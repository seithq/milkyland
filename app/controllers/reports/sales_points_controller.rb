class Reports::SalesPointsController < ApplicationController
  def show
  end

  def create
    @orders = orders_scope
    @data   = prepare_data @orders
  end

  private
    def orders_scope
      base_scope = Order.all
      if report_params[:preferred_date].present?
        start_date, end_date = date_range
        base_scope = base_scope.filter_by_preferred_date_in_between start_date, end_date
      end
      if report_params[:client_id].present?
        base_scope = base_scope.filter_by_client report_params[:client_id]
      end
      if report_params[:sales_point_id].present?
        base_scope = base_scope.filter_by_sales_point report_params[:sales_point_id]
      end
      base_scope.report_for_clients_and_sales_point
    end

    def report_params
      params.expect(report: %i[ client_id sales_point_id preferred_date ])
    end

    def prepare_data(result)
      result.group_by(&:client).transform_values do |orders|
        orders.group_by(&:sales_point)
      end
    end

    def date_range
      preferred_date = report_params[:preferred_date] || ""
      parts = preferred_date.split("—")
      [ parts.first, parts.second ]
    end
end
