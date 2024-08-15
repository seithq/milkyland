require "test_helper"

class IngredientTest < ActiveSupport::TestCase
  test "should validate presence of ratio" do
    ingredient = Ingredient.new(group: groups(:milk25), material_asset: material_assets(:water))
    assert_not ingredient.save
    assert_equal :blank, ingredient.errors.where(:ratio).first.type
  end
end
