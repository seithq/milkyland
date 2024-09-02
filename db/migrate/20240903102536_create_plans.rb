class CreatePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :plans do |t|
      t.date :production_date
      t.string :status

      t.timestamps
    end
  end
end
