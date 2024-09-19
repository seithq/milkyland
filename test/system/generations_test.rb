require "application_system_test_case"

class GenerationsTest < ApplicationSystemTestCase
  setup do
    @generation = generations(:one)
  end

  test "visiting the index" do
    visit generations_url
    assert_selector "h1", text: "Generations"
  end

  test "should create generation" do
    visit generations_url
    click_on "New generation"

    fill_in "Distributed product", with: @generation.distributed_product_id
    fill_in "Finished at", with: @generation.finished_at
    fill_in "Status", with: @generation.status
    click_on "Create Generation"

    assert_text "Generation was successfully created"
    click_on "Back"
  end

  test "should update Generation" do
    visit generation_url(@generation)
    click_on "Edit this generation", match: :first

    fill_in "Distributed product", with: @generation.distributed_product_id
    fill_in "Finished at", with: @generation.finished_at.to_s
    fill_in "Status", with: @generation.status
    click_on "Update Generation"

    assert_text "Generation was successfully updated"
    click_on "Back"
  end

  test "should destroy Generation" do
    visit generation_url(@generation)
    click_on "Destroy this generation", match: :first

    assert_text "Generation was successfully destroyed"
  end
end
