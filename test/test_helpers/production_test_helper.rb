module ProductionTestHelper
  def sample_generation
    order = orders(:opening)
    assert order.update preferred_date: 10.days.from_now

    plan = Plan.last
    assert plan.update status: :ready_to_production
    assert plan.update status: :in_production

    production_unit = plan.units.last
    assert production_unit.batches.create(loader: users(:loader), tester: users(:tester), machiner: users(:machiner), operator: users(:operator))

    batch = production_unit.batches.last

    packing = batch.build_packing(status: :completed)
    packing.build_products
    assert packing.save

    distribution = batch.build_distribution(status: :completed)
    distribution.build_products
    assert distribution.save
    distributed_product = distribution.products.last
    assert distributed_product.update count: packing.products.last.count

    generation = distributed_product.build_generation(box_requests_attributes: [ { box_packaging_id: box_packagings(:bottle_milk25).id, count: 1 } ])
    assert generation.save

    generation
  end
end
