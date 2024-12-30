require "test_helper"

class ProcessReturnJobTest < ActiveJob::TestCase
  setup do
    create_return_for_departure
  end

  test "should create return waybill and box" do
    assert @return.update status: :approved

    assert_difference "Box.count" do
      assert_difference "Waybill.count" do
        assert_difference "Leftover.count" do
          assert ProcessReturnJob.perform_now @return.id

          box = Box.last
          assert box.qr_image.attached?
          assert_equal zones(:goods_arrival_zone), box.current_position
        end
      end
    end
  end

  private
    def create_return_for_departure
      @waybill = Waybill.new kind: :departure,
                             status: :approved,
                             order: orders(:opening),
                             storage: storages(:goods),
                             sender: users(:daniyar)
      assert @waybill.save
      assert @waybill.leftovers.create subject: products(:milk25), count: 6

      @return = Return.new user: users(:daniyar),
                           order: orders(:opening),
                           storage: storages(:goods)
      assert @return.save

      @returned_product = @return.returned_products.new product: products(:milk25), count: 2
      assert @returned_product.save
    end
end
