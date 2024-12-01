class Mobile::ZoneScanComponent < ApplicationComponent
  option :zone
  option :readonly, default: proc { false }
  option :is_open, default: proc { true }
  option :input_name, optional: true
  option :input_value, optional: true
end
