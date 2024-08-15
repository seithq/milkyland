class CreateJournals < ActiveRecord::Migration[8.0]
  def change
    create_table :journals do |t|
      t.references :group, null: false, foreign_key: true
      t.string :name
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :journals, [ :group_id, :name ], unique: true
  end
end
