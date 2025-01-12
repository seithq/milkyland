class Reports::ProductLeftoversController < ApplicationController
  def show
  end

  def create
    @leftovers = leftovers_scope
    @data      = prepare_data @leftovers
  end

  private

  def leftovers_scope
    base_scope = Leftover.all
    if report_params[:storage_id].present?
      base_scope = base_scope.filter_by_storage report_params[:storage_id]
    end
    base_scope.report_for_products
  end

  def report_params
    params.expect(report: %i[ storage_id ])
  end

  def prepare_data(result)
    result.group_by { |row| "#{ row[:group_id] }@#{ row[:group_name] }" }.transform_values do |products|
      products.map do |record|
        {
          id: record.product_id,
          name: record.product_name,
          total_count: record.total_count
        }
      end
    end
  end
end
