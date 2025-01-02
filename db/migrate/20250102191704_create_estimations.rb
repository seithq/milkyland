class CreateEstimations < ActiveRecord::Migration[8.1]
  def change
    create_table :estimations do |t|
      t.references :sales_plan, null: false, foreign_key: true
      t.references :sales_channel, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :planned_count

      t.timestamps
    end
  end
end
