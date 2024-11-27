require "test_helper"

class ScanTest < ActiveSupport::TestCase
  test "should scan zone with kind" do
    zone = zones(:goods_zone)
    assert Scan.find_by zone.code, allowed_prefixes: %w[ Z ]
    assert Scan.find_by zone.code, allowed_prefixes: %w[ Z:A Z:H ]

    assert_not Scan.find_by zone.code, allowed_prefixes: %w[ Z:A ]
    assert_not Scan.find_by zone.code, allowed_prefixes: %w[ Z:S ]

    assert_not Scan.find_by zone.code, allowed_prefixes: %w[ T ]
    assert_not Scan.find_by zone.code, allowed_prefixes: %w[ P ]
  end

  test "should scan tier" do
    tier = tiers(:goods_zone_line_stack_tier)
    assert Scan.find_by tier.code, allowed_prefixes: %w[ T ]
    assert Scan.find_by tier.code, allowed_prefixes: %w[ P T ]

    assert_not Scan.find_by tier.code, allowed_prefixes: %w[ Z:A ]
    assert_not Scan.find_by tier.code, allowed_prefixes: %w[ Z:S ]
  end
end
