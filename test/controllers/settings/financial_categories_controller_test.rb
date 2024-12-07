require "test_helper"

class Settings::FinancialCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @financial_category = financial_categories(:income_client)
    sign_in :daniyar
  end

  test "should get index" do
    get financial_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_financial_category_url
    assert_response :success
  end

  test "should create financial_category" do
    assert_difference("FinancialCategory.count") do
      post financial_categories_url, params: { financial_category: { kind: :expense, name: "Other" } }
    end

    assert_redirected_to financial_categories_url
  end

  test "should show financial_category" do
    get financial_category_url(@financial_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_financial_category_url(@financial_category)
    assert_response :success
  end

  test "should update financial_category" do
    patch financial_category_url(@financial_category), params: { financial_category: { name: "New Name" } }
    assert_redirected_to financial_categories_url
  end

  test "should destroy financial_category" do
    assert_difference("FinancialCategory.count", -1) do
      delete financial_category_url(@financial_category)
    end

    assert_redirected_to financial_categories_url
  end
end
