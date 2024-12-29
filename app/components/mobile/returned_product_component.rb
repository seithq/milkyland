class Mobile::ReturnedProductComponent < ApplicationComponent
  option :record
  option :is_open, default: proc { false }
end
