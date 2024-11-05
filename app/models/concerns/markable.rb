module Markable
  extend ActiveSupport::Concern

  included do
    attribute :index_position, :integer, default: 0

    after_create :assign_display_index

    scope :ordered, -> { order(display_index: :asc) }
    scope :reverse_ordered, -> { order(display_index: :desc) }
  end

  private
    def assign_display_index
      update! display_index: number_to_letter(self.index_position + 1)
    end

    def number_to_letter(n)
      result = ""
      while n > 0
        n -= 1
        result.prepend((65 + n % 26).chr)
        n /= 26
      end
      result
    end
end
