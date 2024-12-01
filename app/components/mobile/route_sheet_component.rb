class Mobile::RouteSheetComponent < ApplicationComponent
  option :route_sheet
  option :is_open, default: proc { false }
end
