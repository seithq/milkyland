require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "should validate uniqueness of name" do
    category = Category.new(name: categories(:milk).name)
    assert_not category.save
    assert_equal :taken, category.errors.where(:name).first.type
  end

  test "should validate presence of name" do
    category = Category.new
    assert_not category.save
    assert_equal :blank, category.errors.where(:name).first.type
  end
end
