require 'sinatra/base'
require 'NBA_info'
require 'json'

# Simple version of nba_scrapper
class NBACatcherApp < Sinatra::Base
  helpers do
    def get_profile(playername)
      sam = Scraper.new
      profile_after = {
        'name' => playername,
        'profiles' => []
      }

      name = params[:playername]
      sam.profile(name)[0].each do |key, value|
        profile_after['profiles'].push('type' => key, 'number' => value)
      end
      profile_after
    end
  end
  get '/api/v1/player/:playername.json' do
    content_type :json
    get_profile(params[:playername]).to_json
  end
end
