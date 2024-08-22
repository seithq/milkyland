require "application_system_test_case"

class Settings::PromotionsTest < ApplicationSystemTestCase
  setup do
    @promotion = promotions(:big_deal)
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit promotions_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.promotions")
  end

  test "should create promotion" do
    visit promotions_url
    click_on I18n.t("actions.create_record")

    fill_in "promotion_name", with: "New Promo"
    choose "promotion_kind_by_percent"
    fill_in "promotion_discount", with: 10.0
    fill_in "promotion_start_date", with: Time.zone.today
    fill_in "promotion_end_date", with: 7.days.from_now
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Promotion" do
    visit promotions_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "promotion_name", with: "New Promo"
    choose "promotion_kind_by_amount"
    fill_in "promotion_discount", with: 100.0
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end

  test "should destroy Promotion" do
    visit edit_promotion_url(@promotion)

    accept_alert do
      find(".destroy_promotion", match: :first).click
    end

    assert_text I18n.t("actions.promo_deactivated")
  end
end
