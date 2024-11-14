class Scan
  PREFIX_TO_CLASS = HashWithIndifferentAccess.new(
    "B": Box,
    "P": Pallet,
    "T": Tier,
    "S": Stack,
    "L": Line,
    "Z": Zone
  ).freeze

  def self.find_by(code, allowed_prefixes:)
    allowed_prefixes = PREFIX_TO_CLASS.keys if allowed_prefixes.empty?

    parts = code.split("-")
    return if parts.size < 2

    prefix = parts.first
    return unless PREFIX_TO_CLASS.has_key?(prefix) && allowed_prefixes.include?(prefix)

    klass = PREFIX_TO_CLASS[prefix]
    klass.find_by_code code
  end
end
