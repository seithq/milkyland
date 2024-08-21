require "test_helper"

module Settings
  class PackingMachines::ContainersControllerTest < ActionDispatch::IntegrationTest
    setup do
      @container = containers(:bottle_pack)
      @packing_machine = @container.packing_machine
    end

    test "should get index" do
      sign_in :daniyar
      get packing_machine_containers_url(@packing_machine)
      assert_response :success
    end

    test "should get new" do
      sign_in :daniyar
      get new_packing_machine_container_url(@packing_machine)
      assert_response :success
    end

    test "should create container" do
      sign_in :daniyar
      assert_difference("Container.count") do
        post packing_machine_containers_url(@packing_machine), params: { container: { losses_percentage: 2, material_asset_id: material_assets(:mini_bottle).id, performance: 2000 } }
      end

      assert_redirected_to edit_packing_machine_url(@packing_machine)
    end

    test "create does not allow non-admins to create record" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      post packing_machine_containers_url(@packing_machine), params: { container: { losses_percentage: 2, material_asset_id: material_assets(:mini_bottle).id, performance: 2000 } }
      assert_response :forbidden
    end

    test "should get edit" do
      sign_in :daniyar
      get edit_packing_machine_container_url(@packing_machine, @container)
      assert_response :success
    end

    test "should update container" do
      sign_in :daniyar
      patch packing_machine_container_url(@packing_machine, @container), params: { container: { losses_percentage: 2, performance: 2000 } }
      assert_redirected_to edit_packing_machine_url(@packing_machine)
    end

    test "update does not allow non-admins to change roles" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      patch packing_machine_container_url(@packing_machine, @container), params: { container: { losses_percentage: 2, performance: 2000 } }
      assert_response :forbidden
    end

    test "should destroy container" do
      sign_in :daniyar
      assert_difference("Container.active.count", -1) do
        delete packing_machine_container_url(@packing_machine, @container)
      end

      assert_redirected_to edit_packing_machine_url(@packing_machine)
    end
  end
end
