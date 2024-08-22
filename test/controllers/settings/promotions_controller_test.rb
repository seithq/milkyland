require "test_helper"

class Settings::PromotionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @promotion = promotions(:big_deal)
  end

  test "should get index" do
    sign_in :daniyar
    get promotions_url
    assert_response :success
  end

  test "should get new" do
    sign_in :daniyar
    get new_promotion_url
    assert_response :success
  end

  test "should create promotion" do
    sign_in :daniyar
    assert_difference("Promotion.count") do
      post promotions_url, params: { promotion: { name: "New Promo", kind: :by_percent, discount: 10.0, start_date: Time.zone.today, end_date: 7.days.from_now } }
    end

    assert_redirected_to edit_promotion_url(Promotion.last)
  end

  test "create does not allow non-admins to create record" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    post promotions_url, params: { promotion: { name: "New Promo", kind: :by_percent, discount: 10.0, start_date: Time.zone.today, end_date: 7.days.from_now } }
    assert_response :forbidden
  end

  test "should show promotion" do
    sign_in :daniyar
    get promotion_url(@promotion)
    assert_response :success
  end

  test "should get edit" do
    sign_in :daniyar
    get edit_promotion_url(@promotion)
    assert_response :success
  end

  test "should update promotion" do
    sign_in :daniyar
    patch promotion_url(@promotion), params: { promotion: { discount: 20.0 } }
    assert_redirected_to promotions_url
  end

  test "update does not allow non-admins to change roles" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    patch promotion_url(@promotion), params: { promotion: { discount: 20.0 } }
    assert_response :forbidden
  end

  test "should destroy promotion" do
    sign_in :daniyar
    assert_difference("Promotion.active.count", -1) do
      delete promotion_url(@promotion)
    end

    assert_redirected_to promotions_url
  end
end
