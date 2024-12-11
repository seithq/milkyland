class AddSuppliableToArticles < ActiveRecord::Migration[8.1]
  def change
    add_column :articles, :suppliable, :boolean, default: false
  end
end
