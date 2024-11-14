class AddStatusToWaybills < ActiveRecord::Migration[8.0]
  def change
    add_column :waybills, :status, :string
  end
end
