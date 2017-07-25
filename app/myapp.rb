require 'sinatra'

require_relative 'sam.rb'
require_relative 'fapiis.rb'

def screenshots_duns_folder
  'screenshots/duns/'
end
set :public_folder, screenshots_duns_folder

get '/' do
  redirect to ('/search')
end

get '/search'  do
  erb :'searchbox', layout: :dashboard
end

get '/duns' do
  @results = {}
  @duns = params['duns']
  @results = @results.merge SamScraper.scrape(@duns)
  @results = @results.merge FapiisScraper.scrape(@duns)
  erb :index, layout: :dashboard
end
