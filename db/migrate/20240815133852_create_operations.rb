class CreateOperations < ActiveRecord::Migration[8.0]
  def change
    create_table :operations do |t|
      t.references :journal, null: false, foreign_key: true
      t.string :name
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :operations, [ :journal_id, :name ], unique: true
  end
end
