require "test_helper"

class BoxPackagingTest < ActiveSupport::TestCase
  test "should validate uniqueness of product and material asset" do
    pack = BoxPackaging.new(product: products(:milk25), material_asset: material_assets(:сardboard), count: 6)
    assert pack.invalid?
    assert_equal :taken, pack.errors.where(:material_asset_id).first.type
  end
end
