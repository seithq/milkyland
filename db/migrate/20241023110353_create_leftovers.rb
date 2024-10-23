class CreateLeftovers < ActiveRecord::Migration[8.0]
  def change
    create_table :leftovers do |t|
      t.references :waybill, null: false, foreign_key: true
      t.references :storage, null: false, foreign_key: true
      t.references :subject, polymorphic: true, null: false
      t.decimal :count, precision: 20, scale: 2
      t.references :parent, null: true, foreign_key: { to_table: :leftovers }

      t.timestamps
    end
  end
end
