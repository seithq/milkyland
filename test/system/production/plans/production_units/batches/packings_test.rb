require "application_system_test_case"

class PackingsTest < ApplicationSystemTestCase
  setup do
    sample_generation
    complete_journals @batch
    assert @packing.update status: :in_progress
    sign_in "daniyar@hey.com"
  end

  test "should create packing" do
    assert @packing.destroy

    visit new_production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)

    accept_alert do
      click_on I18n.t("actions.start")
    end

    assert_text Packing.enum_to_s(:statuses, :in_progress)
  end

  test "should update Packing" do
    visit production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)

    click_on "packing-menu-button"
    accept_alert do
      click_on I18n.t("actions.finish")
    end

    assert_text Packing.enum_to_s(:statuses, :completed)
  end
end
