class Packing < ApplicationRecord
  include Progressable

  belongs_to :batch

  def step_completed?
    completed? || cancelled?
  end

  def build_commodities

  end
end
