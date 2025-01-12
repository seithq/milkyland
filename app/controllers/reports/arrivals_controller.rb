class Reports::ArrivalsController < ApplicationController
  def show
  end

  def create
    @waybills = waybills_scope
    @data     = prepare_data @waybills
  end

  private
    def waybills_scope
      base_scope = Waybill.all
      if report_params[:storage_id].present?
        base_scope = base_scope.filter_by_new_storage report_params[:storage_id]
      end
      if report_params[:date].present?
        base_scope = base_scope.filter_by_date report_params[:date].to_date
      end
      base_scope.report_for_arrivals
    end

    def report_params
      params.expect(report: %i[ date storage_id ])
    end

    def prepare_data(result)
      result.group_by { |row| "#{ row[:group_id] }@#{ row[:group_name] }" }.transform_values do |products|
        products.group_by { |row| "#{ row[:product_id] }@#{ row[:product_name] }" }.transform_values do |records|
          records.map do |record|
            {
              total_count: record.total_count,
              production_date: record.production_date
            }
          end
        end
      end
    end
end
