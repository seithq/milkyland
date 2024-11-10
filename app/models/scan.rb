class Scan
  PREFIX_TO_CLASS = HashWithIndifferentAccess.new(
    "B": Box,
    "P": Pallet,
    "T": Tier,
    "S": Stack,
    "L": Line,
    "Z": Zone
  ).freeze

  def self.find_by(code)
    parts = code.split("-")
    return if parts.size < 2

    prefix = parts.first
    return unless PREFIX_TO_CLASS.has_key? prefix

    klass = PREFIX_TO_CLASS[prefix]
    klass.find_by_code code
  end
end
