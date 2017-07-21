require_relative 'sam.rb'

results = {}

results = results.merge SamScraper.scrape(927755033)
results = results.merge FapiisScraper.scrape(927755033)

puts results
