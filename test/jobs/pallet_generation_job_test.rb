require "test_helper"

class PalletGenerationJobTest < ActiveJob::TestCase
  setup do
    @generation = sample_generation
    @request = @generation.pallet_requests.new(count: 1)
    assert @request.save
  end

  test "should generate pallets" do
    assert_difference("Pallet.count") do
      assert PalletGenerationJob.perform_now @request.id
    end
  end
end
