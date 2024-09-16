class AddCollectionToFields < ActiveRecord::Migration[8.0]
  def change
    add_column :fields, :collection, :string
  end
end
