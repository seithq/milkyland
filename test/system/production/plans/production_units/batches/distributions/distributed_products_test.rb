require "application_system_test_case"

module Production::Plans::ProductionUnits::Batches
  class Distributions::DistributedProductsTest < ApplicationSystemTestCase
    setup do
      sample_generation
      complete_journals @batch
      assert @distribution.update status: :in_progress
      sign_in "daniyar@hey.com"
    end

    test "should update Distributed product" do
      visit production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      click_on I18n.t("actions.edit_record"), match: :first

      fill_in "distributed_product_production_date", with: Time.zone.today
      fill_in "distributed_product_count", with: @distributed_product.count
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end
  end
end
