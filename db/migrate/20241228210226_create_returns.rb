class CreateReturns < ActiveRecord::Migration[8.1]
  def change
    create_table :returns do |t|
      t.references :user, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.references :storage, null: false, foreign_key: true
      t.string :status
      t.text :comment

      t.timestamps
    end
  end
end
