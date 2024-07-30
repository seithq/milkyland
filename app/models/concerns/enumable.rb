module Enumable
  extend ActiveSupport::Concern

  included do
    def self.enum_to_s(enum_name, enum_value)
      i18n_key = enum_name.to_s.pluralize
      I18n.t("activerecord.enums.#{ model_name.i18n_key }.#{ i18n_key }.#{ enum_value }")
    end
  end
end
