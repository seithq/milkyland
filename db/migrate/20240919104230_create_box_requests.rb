class CreateBoxRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :box_requests do |t|
      t.references :generation, null: false, foreign_key: true
      t.references :box_packaging, null: false, foreign_key: true
      t.integer :count

      t.timestamps
    end
  end
end
