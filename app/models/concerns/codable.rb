module Codable
  extend ActiveSupport::Concern

  included do
    has_one_attached :qr_image, dependent: :purge_later

    before_validation :assign_code, on: :create
    validates_uniqueness_of :code

    scope :filter_by_code, ->(code) { where("LOWER(#{ self.model_name.plural }.code) LIKE ?", like(code)) }

    def assign_code
      self.code = loop do
        new_code = generate_code
        break new_code unless self.class.find_by(code: new_code)
      end
    end

    def caption_key
      self.model_name.singular
    end

    private
      def generate_code
        raise NotImplementedError.new "Implement in subclass"
      end
  end
end
