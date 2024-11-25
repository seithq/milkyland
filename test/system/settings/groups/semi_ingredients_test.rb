require "application_system_test_case"

class SemiIngredientsTest < ApplicationSystemTestCase
  setup do
    @group = groups(:milk25)
    sign_in "daniyar@hey.com"
  end

  test "should create semi ingredient" do
    visit edit_group_path(@group)
    find(".new_semi_ingredient").click

    select semi_products(:bom).name, from: "semi_ingredient_semi_product_id"
    fill_in "semi_ingredient_ratio", with: "100"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Semi ingredient" do
    visit edit_group_path(@group)
    find(".edit_semi_ingredient", match: :first).click

    fill_in "semi_ingredient_ratio", with: "100"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end

  test "should destroy Semi ingredient" do
    visit edit_group_path(@group)

    accept_alert do
      find(".destroy_semi_ingredient", match: :first).click
    end

    assert_text I18n.t("actions.record_deleted")
  end
end
