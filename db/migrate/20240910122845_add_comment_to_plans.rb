class AddCommentToPlans < ActiveRecord::Migration[8.0]
  def change
    add_column :plans, :comment, :text
  end
end
