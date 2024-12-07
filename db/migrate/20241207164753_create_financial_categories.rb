class CreateFinancialCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :financial_categories do |t|
      t.string :kind
      t.string :name

      t.timestamps
    end
    add_index :financial_categories, :name, unique: true
  end
end
