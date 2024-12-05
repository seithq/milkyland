class AddForeignToSuppliers < ActiveRecord::Migration[8.1]
  def change
    add_column :suppliers, :foreign, :boolean, default: false
    add_column :suppliers, :identification_number, :string
  end
end
