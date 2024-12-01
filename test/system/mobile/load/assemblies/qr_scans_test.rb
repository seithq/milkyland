require "application_system_test_case"

module Mobile::Load
  class Assemblies::QrScansTest < ApplicationSystemTestCase
    setup do
      sign_in "daniyar@hey.com"
    end
  end
end
