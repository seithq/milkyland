class CreateCookings < ActiveRecord::Migration[8.1]
  def change
    create_table :cookings do |t|
      t.references :batch, null: false, foreign_key: true
      t.integer :status
      t.text :comment

      t.timestamps
    end
  end
end
