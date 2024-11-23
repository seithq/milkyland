class CreateGenerationDownloads < ActiveRecord::Migration[8.0]
  def change
    create_table :generation_downloads do |t|
      t.references :generation, null: false, foreign_key: true
      t.string :kind
      t.string :status

      t.timestamps
    end
  end
end
