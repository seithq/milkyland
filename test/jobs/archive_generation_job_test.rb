require "test_helper"

class ArchiveGenerationJobTest < ActiveJob::TestCase
  test "should generate archive for boxes" do
    generation = prepare_generation

    download = generation.build_boxes_download kind: :boxes, status: :processing
    assert download.save

    assert ArchiveGenerationJob.perform_now(download.id, generation.zip_name("B"), "Box", generation.boxes.pluck(:id))
    assert download.reload.completed?
    assert download.archive.attached?
  end

  test "should generate archive for pallets" do
    generation = prepare_generation

    download = generation.build_pallets_download kind: :pallets, status: :processing
    assert download.save

    assert ArchiveGenerationJob.perform_now(download.id, generation.zip_name("P"), "Pallet", generation.pallets.pluck(:id))
    assert download.reload.completed?
    assert download.archive.attached?
  end

  private
    def prepare_generation
      generation = sample_generation

      assert_difference "Box.count" do
        assert BoxGenerationJob.perform_now generation.id
      end

      assert PalletRequest.create generation: generation, count: 1
      assert_difference "Pallet.count" do
        assert PalletGenerationJob.perform_now PalletRequest.last.id
      end

      generation
    end
end
