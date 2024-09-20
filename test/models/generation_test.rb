require "test_helper"

class GenerationTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "should generate boxes with qr" do
    assert_enqueued_jobs 1, only: BoxGenerationJob do
      sample_generation
    end
  end
end
