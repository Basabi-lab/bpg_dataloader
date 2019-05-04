require "./lib/bgp_data"
require 'date'

def time_parse(str)
  dt = str.split
  date = dt[0].split('/')
  time = dt[1]

  date = ['20' + date[2], date[0], date[1]].join('/')
  DateTime.parse(date + ' ' + time)
end

def prefix_time(now)
  DateTime.new(now.year, now.month, now.day, now.hour, now.minute, 0)
end

def merge(name, prefix="./datasets")
    # path = File.join([prefix, "raw", name])
    bgps = File.join([prefix, "raw", name, "*"])
    merged_bgp_path = File.join([prefix, "merged", name])
    merged_bgp_file = File.open(merged_bgp_path, "w")

    sorted_bgps = Dir.glob(bgps).sort_by { |bgp|
      bgp.match(/updates.([0-9]{8}\.[0-9]{4})/m)[1].to_f
    }

    dumped = sorted_bgps.map { |bgp|
      `bgpdump #{bgp}`
    }.join()

    merged_bgp_file.puts(dumped)
end

def datetime_minus(a, b)
  ((a - b) * 24 * 60 * 60).to_i
end

def each_minute(name, prefix="./datasets")
  path = File.join([prefix, "merged", name])
  bgp_file = File.open(path, "r")
  dump = bgp_file.read.split(/^\R/m)

  datasets_prefix = "datasets/each_minute/#{name}/"

  t = prefix_time(time_parse(BGPData.new(dump[0]).get_info("TIME")))
  f = File.open(File.join(datasets_prefix, t.to_s), 'w')
  for bgp_text in dump do
    bgp = BGPData.new(bgp_text)
    time_tmp = time_parse(bgp.get_info("TIME"))
    if datetime_minus(time_tmp, t) <= 60
      f.puts bgp.to_s
      f.puts
    else
      t = prefix_time(time_tmp)

      f.close
      f = File.open(File.join(datasets_prefix, t.to_s), 'w')

      f.puts bgp.to_s
      f.puts
    end
  end
end
