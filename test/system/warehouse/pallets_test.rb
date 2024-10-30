require "application_system_test_case"

class Warehouse::PalletsTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit pallets_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.pallets")
  end
end
