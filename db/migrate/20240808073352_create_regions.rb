class CreateRegions < ActiveRecord::Migration[8.0]
  def change
    create_table :regions do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    add_index :regions, :name, unique: true
    add_index :regions, :code, unique: true
  end
end
