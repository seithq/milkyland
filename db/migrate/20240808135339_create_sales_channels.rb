class CreateSalesChannels < ActiveRecord::Migration[8.0]
  def change
    create_table :sales_channels do |t|
      t.string :name

      t.timestamps
    end
    add_index :sales_channels, :name, unique: true
  end
end
