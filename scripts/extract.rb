require './lib/definition'
require './lib/extract'

for d in DATASETS
  procedure(d, ANOMALY_RANGE[d])
end
