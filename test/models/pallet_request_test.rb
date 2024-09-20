require "test_helper"

class PalletRequestTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @generation = sample_generation
  end

  test "should generate pallets with qr" do
    assert_enqueued_jobs 1, only: PalletGenerationJob do
      @generation.pallet_requests.create!(count: 1)
    end
  end
end
