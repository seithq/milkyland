class CreateStacks < ActiveRecord::Migration[8.0]
  def change
    create_table :stacks do |t|
      t.string :code
      t.string :display_index
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :stacks, :code, unique: true
  end
end
