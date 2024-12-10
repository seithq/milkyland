require "test_helper"

class PackagedProductTest < ActiveSupport::TestCase
  test "should return packing machines based on product" do
    assert_difference "PackagedProduct.count" do
      sample_generation
    end

    packaged_product = PackagedProduct.last

    machines = packaged_product.product_packing_machines
    assert_equal 1, machines.count
    assert_equal packing_machines(:bottler), machines.first
  end
end
