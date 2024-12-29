require "test_helper"

module Mobile
  class Load::ReturnsControllerTest < ActionDispatch::IntegrationTest
    setup do
      create_return_for_departure
      sign_in :daniyar
    end

    test "should get index" do
      get tasks_returns_url
      assert_response :success
    end

    test "should show return" do
      get tasks_return_url(@return)
      assert_response :success
    end

    test "should get edit" do
      get edit_tasks_return_url(@return)
      assert_response :success
    end

    test "should update return" do
      patch tasks_return_url(@return), params: { return: { status: :approved } }
      assert_redirected_to tasks_returns_url
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
      end
  end
end
