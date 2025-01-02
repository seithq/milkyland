class CreateSalesPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :sales_plans do |t|
      t.references :region, null: false, foreign_key: true
      t.date :month

      t.timestamps
    end
  end
end
