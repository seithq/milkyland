require "test_helper"

module Mobile
  class Waybills::RecommendationsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in :daniyar
    end
  end
end
