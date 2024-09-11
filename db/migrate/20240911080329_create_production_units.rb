class CreateProductionUnits < ActiveRecord::Migration[8.0]
  def change
    create_table :production_units do |t|
      t.references :plan, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.integer :count
      t.decimal :tonnage
      t.integer :status
      t.text :comment

      t.timestamps
    end
    add_index :production_units, %i[ plan_id group_id ], unique: true
  end
end
