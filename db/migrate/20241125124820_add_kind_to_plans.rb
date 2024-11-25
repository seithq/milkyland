class AddKindToPlans < ActiveRecord::Migration[8.1]
  def change
    add_column :plans, :kind, :string, default: "standard"
  end
end
