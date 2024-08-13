class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :metric_tonne
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
    add_index :groups, :name, unique: true
  end
end
