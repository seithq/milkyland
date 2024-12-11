require "test_helper"

class GenerateTransactionForSupplyOrderJobTest < ActiveJob::TestCase
  test "should generate transaction for supply order" do
    user = users(:daniyar)
    supply_order = supply_orders(:sugar_order)
    assert_difference "Transaction.count", 1 do
      assert GenerateTransactionForSupplyOrderJob.perform_now(supply_order.id, user.id)
      assert_equal supply_order, Transaction.last.supply_order
    end
  end
end
