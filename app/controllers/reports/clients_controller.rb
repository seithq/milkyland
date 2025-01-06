class Reports::ClientsController < ApplicationController
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
      if report_params[:sales_channel_id].present?
        base_scope = base_scope.filter_by_sales_channel report_params[:sales_channel_id]
      end
      if report_params[:client_id].present?
        base_scope = base_scope.filter_by_client report_params[:client_id]
      end
      base_scope.report_for_sales_channels_and_clients
    end

    def report_params
      params.expect(report: %i[ sales_channel_id client_id preferred_date ])
    end

    def prepare_data(result)
      result.group_by(&:sales_channel).transform_values do |orders|
        orders.group_by(&:client)
      end
    end

    def date_range
      preferred_date = report_params[:preferred_date] || ""
      parts = preferred_date.split("—")
      [ parts.first, parts.second ]
    end
end
