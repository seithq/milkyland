module ProductionTestHelper
  def sample_generation
    @order = orders(:opening)
    assert @order.update preferred_date: 10.days.from_now

    @plan = Plan.last
    assert @plan.update status: :ready_to_production
    assert @plan.update status: :in_production

    @production_unit = @plan.units.last
    assert @production_unit.update status: :in_progress
    assert @production_unit.batches.create(planned_tonnage: 1.0, planned_start_time: 1.hour.from_now, loader: users(:loader), tester: users(:tester), machiner: users(:machiner), operator: users(:operator), storage: storages(:masters_material_assets))

    @batch = @production_unit.batches.last
    assert @batch.update status: :in_progress

    @journal = @production_unit.group.journals.last
    @operation = @journal.operations.last

    @packing = @batch.build_packing(status: :completed)
    @packing.build_products
    assert @packing.save

    @packaged_product = @packing.products.last

    @distribution = @batch.build_distribution(status: :completed)
    @distribution.build_products
    assert @distribution.save
    @distributed_product = @distribution.products.last
    assert @distributed_product.update count: @packing.products.last.count

    @generation = @distributed_product.build_generation(box_requests_attributes: [ { box_packaging_id: box_packagings(:bottle_milk25).id, count: 1 } ])
    assert @generation.save

    @generation
  end

  def sample_cooked_semi_product
    @plan = Plan.new(kind: :semi, status: :ready_to_production, production_date: 3.days.from_now)
    assert @plan.save

    @production_unit = @plan.units.new(group: groups(:bom_group), count: 1, tonnage: 10)
    assert @production_unit.save
    assert @production_unit.batches.create(loader: users(:loader), tester: users(:tester), machiner: users(:machiner), operator: users(:operator), storage: storages(:masters_material_assets))

    @batch = @production_unit.batches.last
    assert @batch.update status: :in_progress

    @journal = @production_unit.group.journals.last
    @operation = @journal.operations.last

    @cooking = @batch.build_cooking(status: :completed)
    @cooking.build_semi_products
    assert @cooking.save

    @cooked_semi_product = @cooking.semi_products.last
  end

  def complete_journals(batch)
    journals = batch.production_unit.group.journals
    journals.each do |journal|
      journal.operations.each do |operation|
        step = batch.steps.new(operation_id: operation.id, status: :completed)
        step.build_fields
        step.save
      end
    end
  end
end
