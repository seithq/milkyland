require "test_helper"

module ApplicationCable
  class ConnectionTest < ActionCable::Connection::TestCase
    test "connects with cookies" do
      users(:daniyar).sessions.start!(user_agent: "test", ip_address: "10.0.0.1").tap do |session|
        cookies.signed[:session_token] = session.token
      end

      connect

      assert_equal users(:daniyar), connection.current_user
    end

    test "rejects connection without cookies" do
      assert_reject_connection { connect }
    end
  end
end
