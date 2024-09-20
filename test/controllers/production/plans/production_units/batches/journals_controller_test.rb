require "test_helper"

module Production::Plans::ProductionUnits
  class Batches::JournalsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @order = orders(:opening)
      assert @order.update preferred_date: 10.days.from_now
      @plan = Plan.last
      assert @plan.update status: :ready_to_production
      assert @plan.update status: :in_production
      @production_unit = @plan.units.last
      assert @production_unit.batches.create(loader: users(:loader), tester: users(:tester), machiner: users(:machiner), operator: users(:operator))
      @batch = @production_unit.batches.last
      @journal = @production_unit.group.journals.last
    end

    test "should show journal" do
      sign_in :daniyar
      get production_plan_unit_batch_journal_url(@plan, @production_unit, @batch, @journal)
      assert_response :success
    end
  end
end
