class AddAcceptingUserToReturns < ActiveRecord::Migration[8.1]
  def up
    add_reference :returns, :accepting_user, null: true, foreign_key: { to_table: :users }
    Return.all.each { |record| record.update accepting_user_id: record.user_id }
  end

  def down
    remove_reference :returns, :accepting_user
  end
end
