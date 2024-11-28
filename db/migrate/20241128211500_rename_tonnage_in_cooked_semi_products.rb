class RenameTonnageInCookedSemiProducts < ActiveRecord::Migration[8.1]
  def change
    rename_column :cooked_semi_products, :tonnage, :litrage
  end
end
