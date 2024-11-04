module LocationsHelper
  def current_location(record)
    scope = record.locations
    return if scope.length.zero?

    location_url scope.first
  end

  private
    def location_url(location)
      item = location.positionable
      code = item.code

      case location.positionable_type
      when "Zone"
        storage = item.current_position
        location_link_tag code, storage_zone_url(storage.id, item.id)
      when "Line"
        zone = item.current_position
        storage = zone.current_position
        location_link_tag code, storage_zone_line_url(zone.id, storage.id, item.id)
      when "Stack"
        line = item.current_position
        zone = line.current_position
        storage = zone.current_position
        location_link_tag code, storage_zone_line_stack_url(zone.id, storage.id, line.id, item.id)
      when "Tier"
        stack = item.current_position
        line = stack.current_position
        zone = line.current_position
        storage = zone.current_position
        location_link_tag code, storage_zone_line_stack_tier_url(zone.id, storage.id, line.id, stack.id, item.id)
      when "Pallet"
        location_link_tag code, pallet_url(item.id)
      else
        code
      end
    end

    def location_link_tag(code, path)
      link_to code, path, class: "text-indigo-600", target: "_blank"
    end
end
