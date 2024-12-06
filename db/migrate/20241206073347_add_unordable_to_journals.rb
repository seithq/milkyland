class AddUnordableToJournals < ActiveRecord::Migration[8.1]
  def change
    add_column :journals, :unordable, :boolean, default: false
  end
end
