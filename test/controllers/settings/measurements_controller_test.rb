require "test_helper"

class Settings::MeasurementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @measurement = measurements(:litre)
  end

  test "should get index" do
    sign_in :daniyar
    get measurements_url
    assert_response :success
  end

  test "should get new" do
    sign_in :daniyar
    get new_measurement_url
    assert_response :success
  end

  test "should create measurement" do
    sign_in :daniyar
    assert_difference("Measurement.count") do
      post measurements_url, params: { measurement: { name: "Pieces", unit: "pcs" } }
    end

    assert_redirected_to measurements_url
  end

  test "create does not allow non-admins to create record" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    post measurements_url, params: { measurement: { name: "Pieces", unit: "pcs" } }
    assert_response :forbidden
  end

  test "should show measurement" do
    sign_in :daniyar
    get measurement_url(@measurement)
    assert_response :success
  end

  test "should get edit" do
    sign_in :daniyar
    get edit_measurement_url(@measurement)
    assert_response :success
  end

  test "should update measurement" do
    sign_in :daniyar
    patch measurement_url(@measurement), params: { measurement: { name: "Litre" } }
    assert_redirected_to measurements_url
  end

  test "update does not allow non-admins to change roles" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    patch measurement_url(@measurement), params: { measurement: { name: "Litre" } }
    assert_response :forbidden
  end
end
