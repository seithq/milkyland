class Reports::PivotsController < ApplicationController
  def show
  end

  def create
    @sales_channels = base_scope
  end

  private
    def base_scope
      @date = Date.new(
        report_params["range_period(1i)"].to_i,
        report_params["range_period(2i)"].to_i,
        report_params["range_period(3i)"].to_i
      )

      SalesChannel.report_for_plan_fact @date
    end

    def report_params
      params.expect(report: %i[ range_period ])
    end
end
