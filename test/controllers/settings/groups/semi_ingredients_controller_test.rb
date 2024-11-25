require "test_helper"

module Settings
  class Groups::SemiIngredientsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @semi_ingredient = semi_ingredients(:milk25_bom)
      @group = @semi_ingredient.group
    end

    test "should get index" do
      sign_in :daniyar
      get group_semi_ingredients_url(@group)
      assert_response :success
    end

    test "should get new" do
      sign_in :daniyar
      get new_group_semi_ingredient_url(@group)
      assert_response :success
    end

    test "should create semi_ingredient" do
      sign_in :daniyar
      assert_difference("SemiIngredient.count") do
        post group_semi_ingredients_url(@group), params: { semi_ingredient: { semi_product_id: @semi_ingredient.semi_product_id, ratio: @semi_ingredient.ratio } }
      end

      assert_redirected_to edit_group_path(@group)
    end

    test "create does not allow non-admins to create record" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      post group_semi_ingredients_url(@group), params: { semi_ingredient: { semi_product_id: @semi_ingredient.semi_product_id, ratio: @semi_ingredient.ratio } }
      assert_response :forbidden
    end

    test "should get edit" do
      sign_in :daniyar
      get edit_group_semi_ingredient_url(@group, @semi_ingredient)
      assert_response :success
    end

    test "should update semi_ingredient" do
      sign_in :daniyar
      patch group_semi_ingredient_url(@group, @semi_ingredient), params: { semi_ingredient: { ratio: @semi_ingredient.ratio } }
      assert_redirected_to edit_group_path(@group)
    end

    test "update does not allow non-admins to change roles" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      patch group_semi_ingredient_url(@group, @semi_ingredient), params: { semi_ingredient: { ratio: @semi_ingredient.ratio } }
      assert_response :forbidden
    end

    test "should destroy semi_ingredient" do
      sign_in :daniyar
      assert_difference("SemiIngredient.active.count", -1) do
        delete group_semi_ingredient_url(@group, @semi_ingredient)
      end

      assert_redirected_to edit_group_path(@group)
    end
  end
end
