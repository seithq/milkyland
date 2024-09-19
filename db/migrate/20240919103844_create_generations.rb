class CreateGenerations < ActiveRecord::Migration[8.0]
  def change
    create_table :generations do |t|
      t.references :distributed_product, null: false, foreign_key: true
      t.string :status
      t.datetime :finished_at

      t.timestamps
    end
  end
end
