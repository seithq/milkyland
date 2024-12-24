class AddOrderToWaybills < ActiveRecord::Migration[8.1]
  def change
    add_reference :waybills, :order, null: true, foreign_key: true
  end
end
