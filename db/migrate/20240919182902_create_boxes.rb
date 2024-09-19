class CreateBoxes < ActiveRecord::Migration[8.0]
  def change
    create_table :boxes do |t|
      t.string :code
      t.references :region, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :capacity
      t.date :production_date
      t.date :expiration_date
      t.references :box_request, null: true, foreign_key: true
      t.datetime :scanned_at

      t.timestamps
    end
    add_index :boxes, :code, unique: true
  end
end
