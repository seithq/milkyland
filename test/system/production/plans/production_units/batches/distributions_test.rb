require "application_system_test_case"

class DistributionsTest < ApplicationSystemTestCase
  setup do
    sample_generation
    complete_journals @batch
    assert @distribution.update status: :in_progress
    sign_in "daniyar@hey.com"
  end

  test "should create distribution" do
    assert @distribution.destroy

    visit new_production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)

    accept_alert do
      click_on I18n.t("actions.start")
    end

    assert_text Distribution.enum_to_s(:statuses, :in_progress)
  end

  test "should update Distribution" do
    visit production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)

    click_on "distribution-menu-button"
    accept_alert do
      click_on I18n.t("actions.finish")
    end

    assert_text Distribution.enum_to_s(:statuses, :completed)
  end
end
