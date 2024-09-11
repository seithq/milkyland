class CreateBatches < ActiveRecord::Migration[8.0]
  def change
    create_table :batches do |t|
      t.references :production_unit, null: false, foreign_key: true
      t.references :machiner, null: false, foreign_key: { to_table: :users }
      t.references :tester, null: false, foreign_key: { to_table: :users }
      t.references :operator, null: false, foreign_key: { to_table: :users }
      t.references :loader, null: false, foreign_key: { to_table: :users }
      t.integer :status
      t.text :comment

      t.timestamps
    end
  end
end
