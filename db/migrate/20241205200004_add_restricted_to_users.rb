class AddRestrictedToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :restricted, :boolean, default: false
  end
end
