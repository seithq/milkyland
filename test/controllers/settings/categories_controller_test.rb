require "test_helper"

class Settings::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:milk)
  end

  test "should get index" do
    sign_in :daniyar
    get categories_url
    assert_response :success
  end

  test "should get new" do
    sign_in :daniyar
    get new_category_url
    assert_response :success
  end

  test "should create category" do
    sign_in :daniyar
    assert_difference("Category.count") do
      post categories_url, params: { category: { kind: :end_product, name: "Yogurt" } }
    end

    assert_redirected_to categories_url
  end

  test "create does not allow non-admins to create record" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    post categories_url, params: { category: { kind: :end_product, name: "Yogurt" } }
    assert_response :forbidden
  end

  test "should show category" do
    sign_in :daniyar
    get category_url(@category)
    assert_response :success
  end

  test "should get edit" do
    sign_in :daniyar
    get edit_category_url(@category)
    assert_response :success
  end

  test "should update category" do
    sign_in :daniyar
    patch category_url(@category), params: { category: { kind: :end_product, name: "Yogurt" } }
    assert_redirected_to categories_url
  end

  test "update does not allow non-admins to change roles" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    patch category_url(@category), params: { category: { kind: :end_product, name: "Yogurt" } }
    assert_response :forbidden
  end
end
