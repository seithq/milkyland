require "test_helper"

class RegionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @region = regions(:aktobe)
  end

  test "should get index" do
    sign_in :daniyar
    get regions_url
    assert_response :success
  end

  test "should get new" do
    sign_in :daniyar
    get new_region_url
    assert_response :success
  end

  test "should create region" do
    sign_in :daniyar
    assert_difference("Region.count") do
      post regions_url, params: { region: { code: "02", name: "Almaty" } }
    end

    assert_redirected_to regions_url
  end

  test "create does not allow non-admins to create record" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    post regions_url, params: { region: { code: "02", name: "Almaty" } }
    assert_response :forbidden
  end

  test "should show region" do
    sign_in :daniyar
    get region_url(@region)
    assert_response :success
  end

  test "should get edit" do
    sign_in :daniyar
    get edit_region_url(@region)
    assert_response :success
  end

  test "should update region" do
    sign_in :daniyar
    patch region_url(@region), params: { region: { code: @region.code, name: "Almaty" } }
    assert_redirected_to regions_url
  end

  test "update does not allow non-admins to change roles" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    patch region_url(@region), params: { region: { code: @region.code, name: "Almaty" } }
    assert_response :forbidden
  end
end
