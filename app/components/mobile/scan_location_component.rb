class Mobile::ScanLocationComponent < ApplicationComponent
  def initialize(sourceable:)
    @position = sourceable.current_position
  end
end
