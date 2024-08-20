class CreatePackingMachines < ActiveRecord::Migration[8.0]
  def change
    create_table :packing_machines do |t|
      t.string :name

      t.timestamps
    end
    add_index :packing_machines, :name, unique: true
  end
end
