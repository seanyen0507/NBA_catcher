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
      # sean = Scraper.new
      # is_null = 'true'
      # coming_game = Hash[sean.game[0].zip(sean.game[2])]
      # coming_game.each do |key, value|
      #   if value.include?(playername)
      #     @profile_after['game'].push(key)
      #     @profile_after['competitor'].push(value)
      #     is_null = 'false'
      #   end
      # end
      # if is_null
      #   @profile_after['game'].push('status' => 'noGame')
      #   @profile_after['competitor'].push('competitors' => 'noGame')
      # end
      # @profile_after

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
      # startlineup = req['startlineup']
      check_start_lineup(playernames).to_json
    end

    # get '/game/:playername.json' do
    #   content_type :json
    #   get_profile(params[:playername]).to_json
    #   get_start_lineup(params[:playername]).to_json
    # end
  end
end
