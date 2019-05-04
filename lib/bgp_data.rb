class BGPData
  def initialize(msg)
    @info = {}
    is_oneline = true
    for m in msg.split(/\R/) do
      if m.match(':')
        lst = m.split(': ')

        if lst[0].match('ASPATH')
          if lst[1].match('!Error!')
            lst[1] = ''
          end
        end

        @info[lst[0].strip()] = lst[1].strip()
        is_oneline = true
      elsif is_oneline != true
        @info[is_oneline].push(m.strip())
      else
        is_oneline = m.strip()
        @info[is_oneline] = []
      end
    end
  end

  def get_raw_info()
    @info
  end

  def get_info(type)
    @info[type]
  end

  def to_s
    @info.keys.map { |key|
      if @info[key].is_a?(String)
        "#{key}: #{@info[key]}"
      else
        if @info[key].length == 0
          "#{key}"
        else
          "#{key}\n  #{@info[key].join("\n  ")}"
        end
      end
    }.join("\n")
  end
end
