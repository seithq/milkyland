module WaybillsHelper
  def mobile_waybill_form_url(waybill)
    if waybill.new_record?
      url_for(action: "create", controller: "mobile/waybills/#{ waybill.kind }s", only_path: true)
    else
      url_for(action: "update", controller: "mobile/waybills/#{ waybill.kind }s", id: waybill.id, only_path: true)
    end
  end
end
