require "test_helper"

class UpdateSupplyOrderPaymentStatusJobTest < ActiveJob::TestCase
  test "should update payment status for completed transaction" do
    user = users(:daniyar)
    supply_order = supply_orders(:sugar_order)
    assert GenerateTransactionForSupplyOrderJob.perform_now(supply_order.id, user.id)

    transaction = Transaction.last
    assert transaction.update status: :completed, execution_date: Date.current

    assert UpdateSupplyOrderPaymentStatusJob.perform_now transaction.id
    assert supply_order.reload.paid?
  end
end
