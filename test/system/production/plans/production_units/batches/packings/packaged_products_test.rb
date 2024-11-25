require "application_system_test_case"

module Production::Plans::ProductionUnits::Batches
  class Packings::PackagedProductsTest < ApplicationSystemTestCase
    setup do
      sample_generation
      complete_journals @batch
      assert @packing.update status: :in_progress
      sign_in "daniyar@hey.com"
    end

    test "should update Packaged product" do
      visit production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
      click_on I18n.t("actions.edit_record"), match: :first

      fill_in "packaged_product_start_time", with: 1.hour.ago
      fill_in "packaged_product_end_time", with: Time.zone.now
      fill_in "packaged_product_count", with: @packaged_product.count
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end
  end
end
