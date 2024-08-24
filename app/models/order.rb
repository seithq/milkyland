class Order < ApplicationRecord
  belongs_to :sales_channel
  belongs_to :client
  belongs_to :sales_point
end
