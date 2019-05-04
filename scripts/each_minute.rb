require './lib/definition'
require './lib/dump'

DATASETS.map {|name|
    each_minute(name)
}
