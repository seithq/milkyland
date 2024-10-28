require "application_system_test_case"

class Procurements::SupplyMaterialAssetsTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit supply_material_assets_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.supply_leftovers")
  end
end
