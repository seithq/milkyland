class AddManualApprovalToWaybills < ActiveRecord::Migration[8.0]
  def change
    add_column :waybills, :manual_approval, :boolean, default: false
  end
end
