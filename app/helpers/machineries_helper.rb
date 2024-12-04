module MachineriesHelper
  def machinery_url(machinery)
    if machinery.new_record?
      production_plan_unit_batch_packing_packaged_product_machineries_path(@plan, @production_unit, @batch, @packaged_product)
    else
      production_plan_unit_batch_packing_packaged_product_machinery_path(@plan, @production_unit, @batch, @packaged_product, machinery)
    end
  end
end
