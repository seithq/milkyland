class ChangeStartAndEndInPackagedProducts < ActiveRecord::Migration[8.0]
  def up
    remove_column :packaged_products, :start_time
    remove_column :packaged_products, :end_time

    add_column :packaged_products, :start_time, :datetime
    add_column :packaged_products, :end_time, :datetime
  end

  def down
    remove_column :packaged_products, :start_time
    remove_column :packaged_products, :end_time

    add_column :packaged_products, :start_time, :time
    add_column :packaged_products, :end_time, :time
  end
end
