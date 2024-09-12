class CreateMetrics < ActiveRecord::Migration[8.0]
  def change
    create_table :metrics do |t|
      t.references :step, null: false, foreign_key: true
      t.references :field, null: false, foreign_key: true
      t.string :value

      t.timestamps
    end
  end
end
