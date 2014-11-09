require 'sinatra/base'
require 'sinatra/namespace'
require 'NBA_info'
require 'json'

# Simple version of nba_scrapper
class NBACatcherApp < Sinatra::Base
  register Sinatra::Namespace

  configure :production, :development do
    enable :logging
  end

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

    def check_start_lineup(playernames)
      @lineup = {}
      sean = Scraper.new
      begin
        playernames.each do |playername|
          sean.game[2].each do |playerlist|
            if playerlist.include?(playername)
              @lineup[playername] = 'Yes, he is start line up today'
            end
          end
        end
      rescue
        halt 404
      else
        @lineup
      end
    end
  end

  get '/' do
    'Simmple NBA catcher api/v1 is up and working'
  end

  namespace '/api/v1' do

    get '/player/:playername.json' do
      content_type :json
      get_profile(params[:playername]).to_json
    end

    post '/check' do
      content_type :json
      begin
        req = JSON.parse(request.body.read)
        logger.info req
      rescue
        halt 400
      end
      playernames = req['playernames']
      check_start_lineup(playernames).to_json
    end
  end
end
