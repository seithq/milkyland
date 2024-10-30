require "application_system_test_case"

class BoxesTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit boxes_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.boxes")
  end
end
