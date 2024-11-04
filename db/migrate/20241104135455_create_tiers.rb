class CreateTiers < ActiveRecord::Migration[8.0]
  def change
    create_table :tiers do |t|
      t.string :code
      t.string :display_index
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :tiers, :code, unique: true
  end
end
