class AddTrackableToFields < ActiveRecord::Migration[8.0]
  def change
    add_reference :fields, :trackable, null: true, foreign_key: { to_table: :fields }
  end
end
