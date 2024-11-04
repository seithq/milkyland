module Codable
  extend ActiveSupport::Concern

  included do
    scope :filter_by_code, ->(code) { where("LOWER(code) LIKE ?", like(code)) }

    before_validation :assign_code, on: :create

    validates_uniqueness_of :code

    def assign_code
      self.code = loop do
        new_code = generate_code
        break new_code unless self.class.find_by(code: new_code)
      end
    end

    private
      def generate_code
        raise "Not Implemented"
      end
  end
end
