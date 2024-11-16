class Mobile::WaybillComponent < ApplicationComponent
  option :waybill

  def initialize(waybill:)
    @waybill = waybill
  end

  def icon_tag
    tag.div class: "flex w-16 shrink-0 items-center justify-center text-sm font-medium text-white #{ icon_color }" do
      inline_svg_tag icon_name, class: "size-10"
    end
  end

  private
    def icon_name
      case waybill.kind
      when "arrival"
        "sort-ascending"
      when "transfer"
        "switch-horizontal"
      when "write_off"
        "sort-descending"
      when "departure"
        "switch-vertical"
      else
        "document"
      end + ".svg"
    end

    def icon_color
      case waybill.kind
      when "arrival"
        "bg-green-500"
      when "transfer"
        "bg-blue-600"
      when "write_off"
        "bg-yellow-500"
      when "departure"
        "bg-red-500"
      else
        "bg-gray-100"
      end
    end

    def badge_color
      case waybill.status
      when "approved"
        "bg-green-500"
      else
        "bg-gray-900/80"
      end
    end

    def waybill_url
      url_for(action: "show", controller: "mobile/waybills/#{ waybill.kind }s", id: waybill.id, only_path: true)
    end

    def title
      I18n.t("pages.#{ waybill.kind }", id: waybill.id)
    end
end
