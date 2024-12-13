class AddNameIndexToMaterialAssets < ActiveRecord::Migration[8.1]
  def change
    add_index :material_assets, :name, unique: true
  end
end
