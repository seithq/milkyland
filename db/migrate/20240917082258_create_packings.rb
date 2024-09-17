class CreatePackings < ActiveRecord::Migration[8.0]
  def change
    create_table :packings do |t|
      t.references :batch, null: false, foreign_key: true
      t.integer :status
      t.text :comment

      t.timestamps
    end
  end
end
