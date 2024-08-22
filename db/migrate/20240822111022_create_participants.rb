class CreateParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :participants do |t|
      t.references :promotion, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :participants, [ :promotion_id, :client_id ], unique: true
  end
end
