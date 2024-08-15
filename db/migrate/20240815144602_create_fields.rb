class CreateFields < ActiveRecord::Migration[8.0]
  def change
    create_table :fields do |t|
      t.references :operation, null: false, foreign_key: true
      t.string :name
      t.string :kind
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :fields, [ :operation_id, :name ], unique: true
  end
end
