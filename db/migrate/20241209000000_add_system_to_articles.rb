class AddSystemToArticles < ActiveRecord::Migration[8.1]
  def change
    add_column :articles, :system, :boolean, default: false
  end
end
