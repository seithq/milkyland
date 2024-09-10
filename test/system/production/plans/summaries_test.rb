require "application_system_test_case"

module Production
  class Plans::ConsolidationsTest < ApplicationSystemTestCase
    setup do
      sign_in "daniyar@hey.com"
    end
  end
end
