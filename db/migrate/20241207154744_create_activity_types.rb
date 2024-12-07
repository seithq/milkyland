class CreateActivityTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_types do |t|
      t.string :name

      t.timestamps
    end
    add_index :activity_types, :name, unique: true
  end
end
