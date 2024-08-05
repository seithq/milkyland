module EnumsHelper
  def options_for_enum_select(model, enum_name, enum_value, excluded_options: [])
    options = model.send(enum_name.to_s.pluralize).except(*excluded_options)
    options_for_select(options.map { |k, v| [ model.send("enum_to_s", enum_name, options.key(v)), k ] }, enum_value)
  end
end
