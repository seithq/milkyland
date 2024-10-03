class AddTimeWindowToFields < ActiveRecord::Migration[8.0]
  def change
    add_column :fields, :time_window, :integer
  end
end
