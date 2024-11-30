require "test_helper"

module Mobile
  class Load::AssembliesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @assembly = assemblies(:one)
    end

    test "should get index" do
      get assemblies_url
      assert_response :success
    end

    test "should get new" do
      get new_assembly_url
      assert_response :success
    end

    test "should create assembly" do
      assert_difference("Assembly.count") do
        post assemblies_url, params: { assembly: { route_sheet_id: @assembly.route_sheet_id, status: @assembly.status, user_id: @assembly.user_id, zone_id: @assembly.zone_id } }
      end

      assert_redirected_to assembly_url(Assembly.last)
    end

    test "should show assembly" do
      get assembly_url(@assembly)
      assert_response :success
    end

    test "should get edit" do
      get edit_assembly_url(@assembly)
      assert_response :success
    end

    test "should update assembly" do
      patch assembly_url(@assembly), params: { assembly: { route_sheet_id: @assembly.route_sheet_id, status: @assembly.status, user_id: @assembly.user_id, zone_id: @assembly.zone_id } }
      assert_redirected_to assembly_url(@assembly)
    end

    test "should destroy assembly" do
      assert_difference("Assembly.count", -1) do
        delete assembly_url(@assembly)
      end

      assert_redirected_to assemblies_url
    end
  end
end
