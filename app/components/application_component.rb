class ApplicationComponent < ViewComponent::Base
  extend Dry::Initializer
  include Turbo::FramesHelper, Pagy::Frontend
end
