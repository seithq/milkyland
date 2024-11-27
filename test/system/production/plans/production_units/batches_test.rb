require "application_system_test_case"

module Production::Plans
  class ProductionUnits::BatchesTest < ApplicationSystemTestCase
    setup do
      sample_generation
      sign_in "daniyar@hey.com"
    end

    test "visiting the index" do
      visit production_plan_unit_batches_url(@plan, @production_unit)
      assert_selector "p", text: I18n.t("pages.batch", id: @batch.id)
    end

    test "should create batch" do
      visit production_plan_unit_url(@plan, @production_unit)
      click_on I18n.t("actions.create_batch")

      select users(:machiner).name, from: "batch_machiner_id"
      select users(:tester).name, from: "batch_tester_id"
      select users(:operator).name, from: "batch_operator_id"
      select users(:loader).name, from: "batch_loader_id"
      select storages(:masters_material_assets).name, from: "batch_storage_id"
      fill_in "batch_comment", with: "Testing"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Batch" do
      visit production_plan_unit_url(@plan, @production_unit)
      click_on I18n.t("pages.batch", id: @batch.id)

      click_on "batch-menu-button"
      click_on I18n.t("actions.force_finish")

      fill_in "batch_comment", with: "Testing"
      accept_alert do
        click_on I18n.t("actions.force_finish")
      end

      assert_text I18n.t("actions.record_updated")
    end
  end
end
