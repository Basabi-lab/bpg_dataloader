require 'date'

require 'pycall/import'

require './lib/bgp_data'

include PyCall::Import

def loader(path)
  File.open(path, 'r').read.split(/^\R/m).map {|bgp|
    BGPData.new(bgp)
  }
end

## Feature 1
def number_of_announce(bgps)
  count = 0
  for bgp in bgps do
    if bgp.get_info('ANNOUNCE')
      count += 1
    end
  end

  count
end

## Feature 2
def number_of_withdrawal(bgps)
  count = 0
  for bgp in bgps do
    if bgp.get_info('WITHDRAW')
      count += 1
    end
  end

  count
end

## Feature 3
def number_of_announce_NLRI_prefix(bgps)
  count = 0
  for bgp in bgps do
    announce = bgp.get_info('ANNOUNCE')
    if announce
      count += announce.length
    end
  end

  count
end

## Feature 4
def number_of_withdrawn_NLRI_prefix(bgps)
  count = 0
  for bgp in bgps do
    withdraw = bgp.get_info('WITHDRAW')
    if withdraw
      count += withdraw.length
    end
  end

  count
end

## Feature 5
def average_ASpath_length(bgps)
  count = 0
  aspath_count = 0

  for bgp in bgps do
    aspath = bgp.get_info('ASPATH')
    if aspath
      count += aspath.split(' ').length
      aspath_count += 1
    end
  end

  PyCall.eval("#{count} / (#{aspath_count} + 1e-10)")
end

## Feature 6
def maximum_ASpath_length(bgps)
  m = 0
  for bgp in bgps do
    aspath = bgp.get_info('ASPATH')
    if !aspath then next end

    if aspath.split(' ').length > m
      m = aspath.split(' ').length
    end
  end

  m
end

## Feature 7
def average_unique_ASpath_length(bgps)
  count = 0
  aspath_count = 0

  for bgp in bgps do
    aspath = bgp.get_info('ASPATH')
    if aspath
      count += aspath.split(' ').uniq.length
      aspath_count += 1
    end
  end

  PyCall.eval("#{count} / (#{aspath_count} + 1e-10)")
end

## Feature 8
def number_of_duplicate_announcements(bgps)
  m = {}

  for bgp in bgps do
    announce = bgp.get_info('ANNOUNCE')
    if !announce then next end

    if m.include? announce
      m[announce] += 1
    else
      m[announce] = 1
    end
  end

  m.select {|_, value| value > 1}.length
end

## Feature 9
def number_of_duplicate_withdrawals(bgps)
  m = {}

  for bgp in bgps do
    withdraw = bgp.get_info('WITHDRAW')
    if !withdraw then next end

    if m.include? withdraw
      m[withdraw] += 1
    else
      m[withdraw] = 1
    end
  end
  m.select {|_, value| value > 1}.length
end

## Feature 10
def number_of_implicit_withdraw(bgps)
  count = 0

  for i in 0..(bgps.length-2)
    aspath_i = bgps[i].get_info('ASPATH')
    announce_i = bgps[i].get_info('ANNOUNCE')
    if !aspath_i or !announce_i then next end

    for j in (i+1)..(bgps.length-1)
      aspath_j = bgps[j].get_info('ASPATH')
      announce_j = bgps[j].get_info('ANNOUNCE')
      if !aspath_j or !announce_j then next end

      if aspath_i != aspath_j and announce_i == announce_j
        count += 1
      end
    end
  end

  count
end

def edit_distance(str1, str2)
  str1 = str1.split(' ')
  str2 = str2.split(' ')

  n = str1.length
  m = str2.length
  max = n/2

  return m if 0 == n
  return n if 0 == m
  return n if (n - m).abs > max

  d = (0..m).to_a
  x = nil

  str1.each_with_index do |char1,i|
    e = i+1

    str2.each_with_index do |char2,j|
      cost = (char1 == char2) ? 0 : 1
      x = [ d[j+1] + 1, # insertion
            e + 1,      # deletion
            d[j] + cost # substitution
          ].min
      d[j] = e
      e = x
    end

    d[m] = x
  end

  x
end

## Feature 11
def average_edit_distance(bgps)
  count = 0
  edit_dist_sum = 0

  for i in 0..(bgps.length-1)
    aspath_i = bgps[i].get_info('ASPATH')
    if !aspath_i then next end

    for peer in [-1, 1]
      if (i+peer) < 0 or (bgps.length-1) < (i+peer) then next end

      peer_aspath = bgps[i+peer].get_info('ASPATH')
      if !peer_aspath then next end

      edit_dist_sum += edit_distance(aspath_i, peer_aspath)
      count += 1
    end
  end

  PyCall.eval("#{edit_dist_sum} / (#{count} + 1e-10)")
end

## Feature 12
def maximum_edit_distance(bgps)
  edit_dist_max = 0

  for i in 0..(bgps.length-1)
    aspath_i = bgps[i].get_info('ASPATH')
    if !aspath_i then next end

    for peer in [-1, 1]
      if (i+peer) < 0 or (bgps.length-1) < (i+peer) then next end

      peer_aspath = bgps[i+peer].get_info('ASPATH')
      if !peer_aspath then next end

      dist = edit_distance(aspath_i, peer_aspath)
      if edit_dist_max < dist
        edit_dist_max = dist
      end
    end
  end

  edit_dist_max
end

## Feature 13
def inter_arrival_time(bgps)
  'pass'
end

## Feature 14-24
def number_of_edit_distance_7_17(bgps)
  edit_dist_count = Array.new(11).map { |_| 0 }

  for i in 0..(bgps.length-2)
    aspath_i = bgps[i].get_info('ASPATH')
    if !aspath_i then next end

    for peer in [-1, 1]
      if (i+peer) < 0 or (bgps.length-1) < (i+peer) then next end

      peer_aspath = bgps[i+peer].get_info('ASPATH')
      if !peer_aspath then next end

      dist = edit_distance(aspath_i, peer_aspath)
      if dist >= 7 and dist <= 17
        edit_dist_count[dist-7] += 1
      end
    end
  end

  edit_dist_count
end

## Feature 25-33
def number_of_ASpath_length_7_15(bgps)
  aspath_count = Array.new(9).map { |_| 0 }

  for bgp in bgps do
    aspath = bgp.get_info('ASPATH')
    if !aspath then next end
    aspath = aspath.split(' ')

    if aspath.length >= 7 and aspath.length <= 15
      aspath_count[aspath.length-7] += 1
    end
  end

  aspath_count
end

## Feature 34
def number_of_IGP_packets(bgps)
  count = 0

  for bgp in bgps do
    origin = bgp.get_info('ORIGIN')
    if !origin then next end

    if origin == 'IGP' then count += 1 end
  end

  count
end

## Feature 35
def number_of_EGP_packets(bgps)
  count = 0

  for bgp in bgps do
    origin = bgp.get_info('ORIGIN')
    if !origin then next end

    if origin == 'EGP' then count += 1 end
  end

  count
end

## Feature 36
def number_of_INCOMPLETE_packagets(bgps)
  count = 0

  for bgp in bgps do
    origin = bgp.get_info('ORIGIN')
    if !origin then next end

    if origin == 'INCOMPLETE' then count += 1 end
  end

  count
end

## Feature 37
def packet_size(bgps)
  'pass'
end

def extract(bgps)
  [
    number_of_announce(bgps),
    number_of_withdrawal(bgps),
    number_of_announce_NLRI_prefix(bgps),
    number_of_withdrawn_NLRI_prefix(bgps),
    average_ASpath_length(bgps),
    maximum_ASpath_length(bgps),
    average_unique_ASpath_length(bgps),
    number_of_duplicate_announcements(bgps),
    number_of_duplicate_withdrawals(bgps),
    number_of_implicit_withdraw(bgps),
    average_edit_distance(bgps),
    maximum_edit_distance(bgps),
    inter_arrival_time(bgps),
    number_of_edit_distance_7_17(bgps),
    number_of_ASpath_length_7_15(bgps),
    number_of_IGP_packets(bgps),
    number_of_EGP_packets(bgps),
    number_of_INCOMPLETE_packagets(bgps),
    packet_size(bgps)
  ].flatten
end


def procedure(name, anomaly_range)
  puts File.join('datasets/extracted/', "#{name}.csv")
  extract_file = File.open(File.join('datasets/extracted/', "#{name}.csv"), 'w')
  extract_file.puts(LABELS.join(','))

  root_each_minute = File.join('datasets/each_minute', name, '*')
  for bgp_path in `ls -a #{root_each_minute}`.split
    bgps = loader(bgp_path)
    extracted = extract(bgps)
    t = DateTime.parse(File.basename(bgp_path))
    cluster = ''
    if DateTime.parse(anomaly_range[:from]) <= t and t <= DateTime.parse(anomaly_range[:to])
      cluster = 'anomaly'
    else
      cluster = 'regularity'
    end

    extract_file.puts(([File.basename(bgp_path)] + extracted + [cluster]).join(','))
  end

  extract_file.close
end
