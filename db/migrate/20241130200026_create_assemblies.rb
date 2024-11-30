class CreateAssemblies < ActiveRecord::Migration[8.1]
  def change
    create_table :assemblies do |t|
      t.references :route_sheet, null: false, foreign_key: true
      t.references :zone, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
