class AddTriggerToFields < ActiveRecord::Migration[8.0]
  def change
    add_column :fields, :trigger, :string
  end
end
