class CreateLines < ActiveRecord::Migration[8.0]
  def change
    create_table :lines do |t|
      t.string :code
      t.string :display_index
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :lines, :code, unique: true
  end
end
