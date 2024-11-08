module FormsHelper
  class NativeFormBuilder < ActionView::Helpers::FormBuilder
    def submit(value = nil, attributes = {})
      attributes[:data] ||= {}
      attributes["data-bridge--form-target"] = "submit"

      super(value, attributes)
    end
  end

  def auto_submit_form_with(**attributes, &)
    data = attributes.delete(:data) || {}
    data[:controller] = "auto-submit #{data[:controller]}".strip

    form_with **attributes, data: data, &
  end

  def native_form_with(*, **attributes, &block)
    attributes[:html] ||= {}
    attributes[:html][:data] ||= {}
    attributes[:html][:data] = attributes[:html][:data].merge(native_form_data)

    attributes[:builder] = NativeFormBuilder

    form_with(*, **attributes, &block)
  end

  private
    def native_form_data
      {
        controller: "bridge--form",
        action: "turbo:submit-start->bridge--form#submitStart turbo:submit-end->bridge--form#submitEnd"
      }
    end
end
