class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :bin
      t.string :contact_person
      t.string :job_title
      t.string :phone_number
      t.string :email_address
      t.string :entity_code
      t.string :bank_name
      t.string :bank_account
      t.string :bank_code
      t.references :manager, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :clients, :name, unique: true
    add_index :clients, :bin, unique: true
  end
end
