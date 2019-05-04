require 'test/unit'

require './lib/extract'

class TestExtract < Test::Unit::TestCase
  def setup
    sample_file = './datasets/each_minute/nimda/2001-09-15T23:58:00+00:00'
    @@bgps = loader(sample_file)
  end

  def test_number_of_announce
    assert_equal number_of_announce(@@bgps), 18
  end

  def test_number_of_withdrawl
    assert_equal number_of_withdrawal(@@bgps), 5
  end

  def test_number_of_announce_NLRI_prefix
    assert_equal number_of_announce_NLRI_prefix(@@bgps), 30
  end

  def test_number_of_withdrawn_NLRI_prefix
    assert_equal number_of_withdrawn_NLRI_prefix(@@bgps), 18
  end

  def test_average_ASpath_length
    assert_equal average_ASpath_length(@@bgps), 5.166666666637964 # x / (y + 1e-10)で誤差が出てる
  end

  def test_maximum_ASpath_length
    assert_equal maximum_ASpath_length(@@bgps), 9
  end

  def test_average_unique_ASpath_length
    puts average_unique_ASpath_length(@@bgps)
  end

  def test_number_of_duplicate_announcements
    puts number_of_duplicate_announcements(@@bgps)
  end

  def test_number_of_duplicate_withdrawals
    puts number_of_duplicate_withdrawals(@@bgps)
  end

  def test_number_of_implicit_withdraw
    puts number_of_implicit_withdraw(@@bgps)
  end

  def test_average_unique_ASpath_length
    puts average_edit_distance(@@bgps)
  end

  def test_maximum_edit_distance
    puts maximum_edit_distance(@@bgps)
  end

  def test_inter_arrival_time
    assert_equal inter_arrival_time(@@bgps), 'pass'
  end

  def test_number_of_edit_distance_7_17
    p number_of_edit_distance_7_17(@@bgps)
  end

  def test_number_of_ASpath_length_7_15
    p number_of_ASpath_length_7_15(@@bgps)
  end

  def test_number_of_IGP_packets
    puts number_of_IGP_packets(@@bgps)
  end

  def test_number_of_EGP_packets
    puts number_of_EGP_packets(@@bgps)
  end

  def test_number_of_INCOMPLETE_packagets
    puts number_of_INCOMPLETE_packagets(@@bgps)
  end

  def test_packet_size
    assert_equal packet_size(@@bgps), 'pass'
  end
end

class TestEditDistance < Test::Unit::TestCase
  def zero_dist
    x = 'a b c'
    y = 'a b c'
    expect = 0

    # puts '文字列が等しいとき、編集距離は0であること'
    # print '"a s d"', ' ', '"a s d"', ' '
    assert_equal edit_distance(x, y), expect
  end

  def test_insert
    # puts "文字列が一つ足らないとき(insertひとつのコスト)、編集距離は1であること"
    x = 'a s d'
    y = 'a s'
    expect = 1

    assert_equal edit_distance(x, y), expect
    assert_equal edit_distance(y, x), expect
  end

  def test_delete
    # puts "文字列が一つ多いとき(deleteひとつのコスト)、編集距離は1であること"
    x = 'a s d'
    y = 'a s d hoge'
    expect = 1

    assert_equal edit_distance(x, y), expect
    assert_equal edit_distance(y, x), expect
  end

  def test_replace
    # puts "文字列が一つ違うとき(replaceひとつのコスト)、編集距離は1であること"
    x = 'a s d'
    y = 'a s hoge'
    expect = 1

    assert_equal edit_distance(x, y), expect
    assert_equal edit_distance(y, x), expect
  end

  def real_dist
    puts "sample test"
    x = '6893 12541 1273 7176 12885 24673 24673 24673 24673 24673 24673 24673'
    y = '6893 3561 701 10910 10455'
    expect = 11

    assert_equal edit_distance(x, y), expect
    assert_equal edit_distance(y, x), expect
  end
end
