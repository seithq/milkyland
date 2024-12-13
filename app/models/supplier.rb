class Supplier < ApplicationRecord
  include Entitable

  has_many :vendors, dependent: :destroy

  validates_presence_of :identification_number, if: :foreign?
  validates_presence_of :bin, unless: :foreign?
  validates_uniqueness_of :bin, case_sensitive: false, allow_blank: true
  validates_length_of :bin, is: 12, allow_blank: true

  scope :filter_by_name_or_bin, ->(query) { where("LOWER(name) LIKE ? OR LOWER(bin) LIKE ? OR LOWER(identification_number) LIKE ?", like(query), like(query), like(query)) }
end
