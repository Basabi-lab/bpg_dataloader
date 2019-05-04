require './lib/definition'
require './lib/dump'

DATASETS.map {|name|
    merge(name)
}

