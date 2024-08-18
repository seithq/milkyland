require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test "should validate uniqueness of name" do
    client = Client.new(name: clients(:systemd).name, bin: "921026400042")
    assert_not client.save
    assert_equal :taken, client.errors.where(:name).first.type
  end

  test "should validate uniqueness of bin" do
    client =  Client.new(name: "REGATA", bin: clients(:systemd).bin)
    assert_not client.save
    assert_equal :taken, client.errors.where(:bin).first.type
  end

  test "should validate length of bin" do
    test_cases = %w[ 921026 92102640004200 ]
    test_cases.each do |test_case|
      client =  Client.new(name: "REGATA", bin: test_case)
      assert_not client.save
      assert_equal :wrong_length, client.errors.where(:bin).first.type
    end
  end

  test "should validate format of email address" do
    test_cases = %w[ regatamail.ru regatamail ]
    test_cases.each do |test_case|
      client =  Client.new(name: "REGATA", bin: "921026400042", email_address: test_case)
      assert_not client.save
      assert_equal :invalid, client.errors.where(:email_address).first.type
    end
  end

  test "should validate format of phone number" do
    test_cases = %w[ 7772098007 77772098007 +7772098007 ]
    test_cases.each do |test_case|
      client =  Client.new(name: "REGATA", bin: "921026400042", phone_number: test_case)
      assert_not client.save
      assert_equal :invalid, client.errors.where(:phone_number).first.type
    end

    client =  Client.new(manager: users(:askhat), name: "REGATA", bin: "921026400042", phone_number: "+77772098007")
    assert client.save
  end
end
