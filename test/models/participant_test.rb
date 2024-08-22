require "test_helper"

class ParticipantTest < ActiveSupport::TestCase
  test "should validate uniqueness of client id" do
    participant = Participant.new(promotion_id: promotions(:big_deal).id, client_id: clients(:systemd).id)
    assert_not participant.save
    assert_equal :taken, participant.errors.where(:client_id).first.type
  end
end
