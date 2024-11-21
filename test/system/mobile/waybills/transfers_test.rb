require "application_system_test_case"

module Mobile
  class Waybills::TransfersTest < ApplicationSystemTestCase
    setup do
      sign_in "daniyar@hey.com"
    end
  end
end
