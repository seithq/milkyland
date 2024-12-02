require "test_helper"

module Mobile::Load
  class Assemblies::RecommendationsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in :daniyar
    end
  end
end
