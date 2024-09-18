module Progressable
  extend ActiveSupport::Concern

  included do
    enum :status, %i[ in_progress in_plan completed cancelled ], default: :in_plan

    scope :progressable, ->() { order(status: :asc) }

    scope :filter_by_status, ->(status) { where(status: status) }

    def launch
      update status: :in_progress
    end

    def finish
      update status: :completed
    end

    def cancel(comment: "")
      update status: :cancelled, comment: comment
    end

    def step_completed?
      completed? || cancelled?
    end
  end
end
