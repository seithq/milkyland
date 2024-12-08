class CreateArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :articles do |t|
      t.references :financial_category, null: false, foreign_key: true
      t.references :activity_type, null: false, foreign_key: true
      t.string :name
      t.string :kind
      t.boolean :bypass_control, default: false
      t.decimal :min_amount, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end
    add_index :articles, [ :name, :financial_category_id ], unique: true
  end
end
