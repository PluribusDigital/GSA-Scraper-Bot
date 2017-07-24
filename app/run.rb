require_relative 'sam.rb'
require_relative 'fapiis.rb'
# require_relative 'fpds.rb'

results = {}

results = results.merge SamScraper.scrape(927755033)
results = results.merge FapiisScraper.scrape(927755033)
# results = results.merge FpdsScraper.scrape(927755033)
puts results
