class Reports::MaterialAssetLeftoversController < ApplicationController
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
    base_scope.report_for_material_assets
  end

  def report_params
    params.expect(report: %i[ storage_id ])
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
