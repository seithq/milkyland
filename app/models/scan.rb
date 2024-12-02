class Scan
  PREFIX_TO_CLASS = HashWithIndifferentAccess.new(
    "B": Box.active,
    "P": Pallet,
    "T": Tier,
    "S": Stack,
    "L": Line,
    "Z": Zone,
    "Z:A": Zone.filter_by_kind(:arrival),
    "Z:H": Zone.filter_by_kind(:hold),
    "Z:S": Zone.filter_by_kind(:ship)
  ).freeze

  def self.find_by(code, allowed_prefixes: PREFIX_TO_CLASS.keys)
    allowed_prefixes = PREFIX_TO_CLASS.keys if allowed_prefixes.empty?

    parts = code.split("-")
    return if parts.size < 2

    prefix = parts.first
    return unless prefix.present? && PREFIX_TO_CLASS.has_key?(prefix)

    scopes = []
    allowed_prefixes.each do |allowed|
      if PREFIX_TO_CLASS.has_key?(allowed) && allowed.start_with?(prefix)
        scopes << PREFIX_TO_CLASS[allowed]
      end
    end

    return if scopes.empty?

    scopes.each do |scope|
      record = scope.find_by_code code
      return record if record
    end

    nil
  end
end
