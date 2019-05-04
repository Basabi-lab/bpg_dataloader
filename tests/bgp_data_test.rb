require 'test/unit'

require './lib/bgp_data'

class TestBGPData < Test::Unit::TestCase
  def test_new
    msg = '''TIME: 09/15/01 23:58:24
TYPE: BGP4MP/MESSAGE/Update
FROM: 192.65.185.144 AS6893
TO: 192.65.185.40 AS12654
ORIGIN: IGP
ASPATH: 6893 1273 1755 1239 6453 4621
NEXT_HOP: 192.65.185.144
ATOMIC_AGGREGATE
AGGREGATOR: AS4621 202.28.31.1
ANNOUNCE
  202.28.50.0/23
  202.28.51.0/23
  202.28.52.0/23'''

    assert_equal BGPData.new(msg).to_s, msg
  end

  def test_info
    msg = '''TIME: 09/15/01 23:58:24
TYPE: BGP4MP/MESSAGE/Update
FROM: 192.65.185.144 AS6893
TO: 192.65.185.40 AS12654
ORIGIN: IGP
ASPATH: 6893 1273 1755 1239 6453 4621
NEXT_HOP: 192.65.185.144
ATOMIC_AGGREGATE
AGGREGATOR: AS4621 202.28.31.1
ANNOUNCE
  202.28.50.0/23
  202.28.51.0/23
  202.28.52.0/23'''

    expect = {
      'TIME' => '09/15/01 23:58:24',
      'TYPE' => 'BGP4MP/MESSAGE/Update',
      'FROM' => '192.65.185.144 AS6893',
      'TO' => '192.65.185.40 AS12654',
      'ORIGIN' => 'IGP',
      'ASPATH' => '6893 1273 1755 1239 6453 4621',
      'NEXT_HOP' => '192.65.185.144',
      'ATOMIC_AGGREGATE' => [],
      'AGGREGATOR' => 'AS4621 202.28.31.1',
      'ANNOUNCE' => [
        '202.28.50.0/23',
        '202.28.51.0/23',
        '202.28.52.0/23',
      ]
    }

    assert_equal BGPData.new(msg).get_raw_info, expect
  end
end


