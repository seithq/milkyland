require "application_system_test_case"

class Warehouse::WaybillsTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit waybills_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.waybills")
  end
end
