require "application_system_test_case"

module Production::Plans::ProductionUnits::Batches
  class Cookings::CookedSemiProductsTest < ApplicationSystemTestCase
    setup do
      sample_cooked_semi_product
      complete_journals @batch
      assert @cooking.update status: :in_progress
      sign_in "daniyar@hey.com"
    end

    test "should update Cooked semi product" do
      visit production_plan_unit_batch_cooking_url(@plan, @production_unit, @batch)
      click_on I18n.t("actions.edit_record"), match: :first

      fill_in "cooked_semi_product_tonnage", with: @cooked_semi_product.tonnage
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end
  end
end
