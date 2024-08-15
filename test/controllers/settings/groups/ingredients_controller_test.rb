require "test_helper"

module Settings
  class Groups::IngredientsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @ingredient = ingredients(:milk25_sugar)
      @group = @ingredient.group
    end

    test "should get index" do
      sign_in :daniyar
      get group_ingredients_url(@group)
      assert_response :success
    end

    test "should get new" do
      sign_in :daniyar
      get new_group_ingredient_url(@group)
      assert_response :success
    end

    test "should create ingredient" do
      sign_in :daniyar
      assert_difference("Ingredient.count") do
        post group_ingredients_url(@group), params: { ingredient: { material_asset_id: @ingredient.material_asset_id, ratio: @ingredient.ratio } }
      end

      assert_redirected_to edit_group_path(@group)
    end

    test "create does not allow non-admins to create record" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      post group_ingredients_url(@group), params: { ingredient: { material_asset_id: @ingredient.material_asset_id, ratio: @ingredient.ratio } }
      assert_response :forbidden
    end

    test "should get edit" do
      sign_in :daniyar
      get edit_group_ingredient_url(@group, @ingredient)
      assert_response :success
    end

    test "should update ingredient" do
      sign_in :daniyar
      patch group_ingredient_url(@group, @ingredient), params: { ingredient: { ratio: @ingredient.ratio } }
      assert_redirected_to edit_group_path(@group)
    end

    test "update does not allow non-admins to change roles" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      patch group_ingredient_url(@group, @ingredient), params: { ingredient: { ratio: @ingredient.ratio } }
      assert_response :forbidden
    end

    test "should destroy ingredient" do
      sign_in :daniyar
      assert_difference("Ingredient.active.count", -1) do
        delete group_ingredient_url(@group, @ingredient)
      end

      assert_redirected_to edit_group_path(@group)
    end
  end
end
