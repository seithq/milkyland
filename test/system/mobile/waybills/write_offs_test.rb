require "application_system_test_case"

module Mobile
  class Waybills::WriteOffsTest < ApplicationSystemTestCase
    setup do
      sign_in "daniyar@hey.com"
    end
  end
end
