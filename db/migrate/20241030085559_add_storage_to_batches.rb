class AddStorageToBatches < ActiveRecord::Migration[8.0]
  def change
    add_reference :batches, :storage, null: false, foreign_key: true
  end
end
