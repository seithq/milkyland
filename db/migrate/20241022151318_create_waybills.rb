class CreateWaybills < ActiveRecord::Migration[8.0]
  def change
    create_table :waybills do |t|
      t.string :kind
      t.references :storage, null: true, foreign_key: true
      t.references :new_storage, null: true, foreign_key: { to_table: :storages }
      t.references :sender, null: true, foreign_key: { to_table: :users }
      t.references :receiver, null: true, foreign_key: { to_table: :users }
      t.references :batch, null: true, foreign_key: true
      t.text :comment
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
