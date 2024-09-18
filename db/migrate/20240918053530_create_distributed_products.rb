class CreateDistributedProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :distributed_products do |t|
      t.references :distribution, null: false, foreign_key: true
      t.references :packaged_product, null: false, foreign_key: true
      t.references :region, null: false, foreign_key: true
      t.date :production_date
      t.integer :count

      t.timestamps
    end
  end
end
