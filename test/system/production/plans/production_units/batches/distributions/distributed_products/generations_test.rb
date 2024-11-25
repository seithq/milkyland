require "application_system_test_case"

module Production::Plans::ProductionUnits::Batches::Distributions
  class DistributedProducts::GenerationsTest < ApplicationSystemTestCase
    setup do
      sample_generation
      complete_journals @batch
      sign_in "daniyar@hey.com"
    end

    test "should create generation" do
      assert @generation.destroy

      visit production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      click_on I18n.t("actions.print_qr"), match: :first

      fill_in "generation_box_requests_attributes_0_count", with: 1
      accept_alert do
        click_on I18n.t("actions.save_record")
      end

      assert_text I18n.t("actions.record_created")
    end
  end
end
