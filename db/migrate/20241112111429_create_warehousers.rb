class CreateWarehousers < ActiveRecord::Migration[8.0]
  def change
    create_table :warehousers do |t|
      t.references :storage, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
