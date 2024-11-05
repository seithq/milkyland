module AddressSearchable
  extend ActiveSupport::Concern

  included do
    scope :filter_by_address, ->(address) do
      prefix = address.split("-").first.to_sym
      self.prefix_to_scope.has_key?(prefix) ? self.send(self.prefix_to_scope[prefix], address) : self.all
    end

    def self.prefix_to_scope
      raise "Not Implemented"
    end
  end
end
