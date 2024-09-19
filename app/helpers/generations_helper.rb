module GenerationsHelper
  def generation_status_color(generation)
    case generation.status
    when "in_planning"
      "animate-pulse btn-preparing"
    when "processing"
      "animate-pulse btn-in-production"
    when "completed"
      "btn-produced"
    else
      "animate-pulse btn-start"
    end
  end

  def box_packaging_label(box_packaging)
    t("forms.box_packaging_label", name: box_packaging.material_asset.name, count: box_packaging.count)
  end
end
