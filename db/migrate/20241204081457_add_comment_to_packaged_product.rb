class AddCommentToPackagedProduct < ActiveRecord::Migration[8.1]
  def change
    add_column :packaged_products, :comment, :text
  end
end
