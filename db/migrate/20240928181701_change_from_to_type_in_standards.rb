class ChangeFromToTypeInStandards < ActiveRecord::Migration[8.0]
  def change
    change_column :standards, :from, :decimal, precision: 10, scale: 2
    change_column :standards, :to, :decimal, precision: 10, scale: 2
  end
end
