class Reports::WriteOffsController < ApplicationController
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
        base_scope = base_scope.filter_by_storage report_params[:storage_id]
      end
      if report_params[:date].present?
        base_scope = base_scope.filter_by_date report_params[:date].to_date
      end
      base_scope.report_for_write_offs
    end

    def report_params
      params.expect(report: %i[ date storage_id ])
    end

    def prepare_data(result)
      result.group_by { |row| "#{ row[:category_id] }@#{ row[:category_name] }" }.transform_values do |material_assets|
        material_assets.map do |record|
          {
            id: record.material_asset_id,
            name: record.material_asset_name,
            unit: record.measurement_unit,
            total_count: record.total_count
          }
        end
      end
    end
end
