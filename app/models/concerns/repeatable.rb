module Repeatable
  extend ActiveSupport::Concern

  included do
    attribute :repeat, :integer, default: 1

    def self.repeat(n, parent)
      self.transaction do
        n.to_i.times do
          record = self.create!(active: true, index_position: parent.counter_base)
          record.locate_to parent
        end

        true
      rescue ActiveRecord::Rollback
        return false
      end
    end
  end
end
