module Binable
  extend ActiveSupport::Concern

  included do
    validates :bin, presence: true, uniqueness: { case_sensitive: false }, length: { is: 12 }

    scope :filter_by_name_or_bin, ->(query) { where("LOWER(name) LIKE ? OR LOWER(bin) LIKE ?", like(query), like(query)) }
  end
end
