class CreateStandards < ActiveRecord::Migration[8.0]
  def change
    create_table :standards do |t|
      t.references :group, null: false, foreign_key: true
      t.references :measurement, null: false, foreign_key: true
      t.string :name
      t.integer :from
      t.integer :to
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :standards, [ :group_id, :name ], unique: true
  end
end
