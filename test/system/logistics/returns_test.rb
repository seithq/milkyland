require "application_system_test_case"

class Logistics::ReturnsTest < ApplicationSystemTestCase
  setup do
    create_return_for_departure
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit returns_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.returns")
  end

  test "should create return" do
    visit returns_url
    click_on I18n.t("actions.create_record")

    select orders(:opening).display_label, from: "return_order_id"
    select storages(:goods).name, from: "return_storage_id"
    fill_in "return_comment", with: "TEST"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Return" do
    visit returns_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "return_comment", with: "TEST"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end

  test "should destroy Return" do
    visit edit_return_url(@return)

    accept_alert do
      find(".destroy_return", match: :first).click
    end

    assert_text I18n.t("actions.record_deleted")
  end

  private
    def create_return_for_departure
      @waybill = Waybill.new kind: :departure,
                             status: :approved,
                             order: orders(:opening),
                             storage: storages(:goods),
                             sender: users(:daniyar)
      assert @waybill.save
      assert @waybill.leftovers.create subject: products(:milk25), count: 6

      @return = Return.new user: users(:daniyar),
                           order: orders(:opening),
                           storage: storages(:goods)
      assert @return.save
    end
end
