class CreateStorages < ActiveRecord::Migration[8.0]
  def change
    create_table :storages do |t|
      t.string :name
      t.string :kind

      t.timestamps
    end
    add_index :storages, :name, unique: true
  end
end
