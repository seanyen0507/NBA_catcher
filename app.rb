require 'sinatra/base'
require 'NBA_info'
require 'json'

# Simple version of nba_scrapper
class NBACatcherApp < Sinatra::Base
  helpers do
    @profile_after = {}
    def get_profile(playername)
      sam = Scraper.new
      @profile_after = {
        'name' => playername, 'profiles' => [], 'game' => [], 'competitor' => []
      }
      begin
        name = params[:playername]
        sam.profile(name)[0].each do |key, value|
          @profile_after['profiles'].push('Box-score' => key, 'Record' => value)
        end
      rescue
        halt 404
      else
        @profile_after
      end
    end

    def get_start_lineup(playername)

      sean = Scraper.new
      is_null = 'true'
      coming_game = Hash[sean.game[0].zip(sean.game[2])]
      coming_game.each do |key, value|
        if value.include?(playername)
          @profile_after['game'].push(key)
          @profile_after['competitor'].push(value)
          is_null = 'false'
        end
      end
      if is_null
        @profile_after['game'].push('status' => 'noGame')
        @profile_after['competitor'].push('competitors' => 'noGame')
      end
      @profile_after
    end
  end
  get '/api/v1/player/:playername.json' do
    content_type :json
    get_profile(params[:playername]).to_json
  end
  get '/api/v1/game/:playername.json' do
    content_type :json
    get_profile(params[:playername]).to_json
    get_start_lineup(params[:playername]).to_json
  end
end
