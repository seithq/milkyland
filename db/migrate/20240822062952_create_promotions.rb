class CreatePromotions < ActiveRecord::Migration[8.0]
  def change
    create_table :promotions do |t|
      t.string :name
      t.string :kind
      t.date :start_date
      t.date :end_date
      t.decimal :discount, precision: 20, scale: 2
      t.boolean :unlimited, default: false
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :promotions, :name, unique: true
  end
end
