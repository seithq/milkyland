class CreateSteps < ActiveRecord::Migration[8.0]
  def change
    create_table :steps do |t|
      t.references :batch, null: false, foreign_key: true
      t.references :operation, null: false, foreign_key: true
      t.integer :status
      t.text :comment

      t.timestamps
    end
    add_index :steps, %i[batch_id operation_id], unique: true
  end
end
