class CreateConsolidations < ActiveRecord::Migration[8.0]
  def change
    create_table :consolidations do |t|
      t.references :plan, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :consolidations, %i[ plan_id order_id ], unique: true
  end
end
