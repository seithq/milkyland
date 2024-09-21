require "test_helper"

class BoxGenerationJobTest < ActiveJob::TestCase
  setup do
    @generation = sample_generation
    Box.destroy_all
  end

  test "should generate boxes" do
    assert_difference("Box.count") do
      assert BoxGenerationJob.perform_now @generation.id
    end
  end

  test "should not generate boxes unless in planning" do
    assert @generation.finish!
    assert_not BoxGenerationJob.perform_now @generation.id
  end
end
