require "test_helper"

class MaterialAssetTest < ActiveSupport::TestCase
  test "should validate presence of article" do
    asset = MaterialAsset.new(name: "Test Material")
    assert_not asset.save
    assert_equal :blank, asset.errors.where(:article).first.type
  end

  test "should validate uniqueness of article" do
    asset = MaterialAsset.new(name: "Test Material", article: material_assets(:sugar).article)
    assert_not asset.save
    assert_equal :taken, asset.errors.where(:article).first.type
  end

  test "should validate presence of name" do
    asset = MaterialAsset.new(article: "1234567")
    assert_not asset.save
    assert_equal :blank, asset.errors.where(:name).first.type
  end

  test "should validate uniqueness of name" do
    asset = MaterialAsset.new(name: material_assets(:sugar).name, article: "1234567")
    assert_not asset.save
    assert_equal :taken, asset.errors.where(:name).first.type
  end
end
