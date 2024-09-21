require "application_system_test_case"

module Production::Plans::ProductionUnits
  class Batches::StepsTest < ApplicationSystemTestCase
    setup do
      sample_generation
      sign_in "daniyar@hey.com"
    end

    test "should create step" do
      visit production_plan_unit_batch_journal_url(@plan, @production_unit, @batch, @journal)

      accept_alert do
        click_on I18n.t("actions.start"), match: :first
      end

      assert_selector "th", text: I18n.t("tables.cols.plan")
      assert_selector "th", text: I18n.t("tables.cols.fact")

      assert_text Step.enum_to_s(:statuses, :in_progress)
    end

    test "should update Step" do
      visit production_plan_unit_batch_journal_url(@plan, @production_unit, @batch, @journal)

      accept_alert do
        click_on I18n.t("actions.start"), match: :first
      end

      click_on "operation-menu-button"
      click_on I18n.t("actions.finish")

      fill_in "step_metrics_attributes_0_value", with: Time.zone.now
      accept_alert do
        click_on I18n.t("actions.finish")
      end

      assert_text I18n.t("actions.record_updated")
    end
  end
end
