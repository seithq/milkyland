class CreateZones < ActiveRecord::Migration[8.0]
  def change
    create_table :zones do |t|
      t.string :code
      t.string :kind
      t.string :display_index
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :zones, :code, unique: true
  end
end
