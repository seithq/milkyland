class AddStandardToFields < ActiveRecord::Migration[8.0]
  def change
    add_reference :fields, :standard, null: true, foreign_key: true
  end
end
