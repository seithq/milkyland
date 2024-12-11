require "test_helper"

class SupplierTest < ActiveSupport::TestCase
  test "should validate uniqueness of name" do
    supplier = Supplier.new(name: suppliers(:systemd).name, bin: "921026400042")
    assert_not supplier.save
    assert_equal :taken, supplier.errors.where(:name).first.type
  end

  test "should validate uniqueness of bin" do
    supplier = Supplier.new(name: "REGATA", bin: suppliers(:systemd).bin)
    assert_not supplier.save
    assert_equal :taken, supplier.errors.where(:bin).first.type
  end

  test "should validate length of bin" do
    test_cases = %w[ 921026 92102640004200 ]
    test_cases.each do |test_case|
      supplier = Supplier.new(name: "REGATA", bin: test_case)
      assert_not supplier.save
      assert_equal :wrong_length, supplier.errors.where(:bin).first.type
    end
  end

  test "should validate format of email address" do
    test_cases = %w[ regatamail.ru regatamail ]
    test_cases.each do |test_case|
      supplier = Supplier.new(name: "REGATA", bin: "921026400042", email_address: test_case)
      assert_not supplier.save
      assert_equal :invalid, supplier.errors.where(:email_address).first.type
    end
  end

  test "should validate format of phone number" do
    test_cases = %w[ 7772098007 77772098007 +7772098007 ]
    test_cases.each do |test_case|
      supplier = Supplier.new(name: "ARYSTAN", bin: "190717503200", phone_number: test_case)
      assert_not supplier.save
      assert_equal :invalid, supplier.errors.where(:phone_number).first.type
    end

    supplier = Supplier.new(manager: users(:askhat), name: "ARYSTAN", bin: "190717503200", phone_number: "+77772098007")
    assert supplier.save
  end

  test "should validate only identification number for foreign" do
    supplier = Supplier.new(manager: users(:askhat), name: "Foreign Supplier", bin: "", foreign: true, identification_number: "1234567890")
    assert supplier.valid?
  end
end
