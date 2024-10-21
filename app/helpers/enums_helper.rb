module EnumsHelper
  def options_for_enum_select(model, enum_name, enum_value, excluded_options: [])
    options_for_select(get_collection(model, enum_name, excluded_options), enum_value)
  end

  def search_enum_selector(model, enum_name, class_name = "", placeholder = "", excluded_options: [])
    collection_select :search, enum_name, get_collection(model, enum_name, excluded_options), :second, :first, { include_blank: placeholder }, { class: class_name }
  end

  private
  def get_collection(model, enum_name, excluded_options = [])
    options = model.send(enum_name.to_s.pluralize).except(*excluded_options)
    options.map { |k, v| [ model.send("enum_to_s", enum_name, options.key(v)), k ] }
  end
end
