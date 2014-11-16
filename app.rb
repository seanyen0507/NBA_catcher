require 'sinatra/base'
require_relative 'model/nbaplayer'
# require 'sinatra/namespace'
require 'NBA_info'
require 'json'

# Simple version of nba_scrapper
class NBACatcherApp < Sinatra::Base
  # register Sinatra::Namespace

  configure :production, :development do
    enable :logging
  end

  helpers do
    def get_profile(playername)
      sam = Scraper.new
      profile_after = {
        'name' => playername, 'profiles' => []
      }
      begin
        name = params[:playername]
        sam.profile(name)[0].each do |key, value|
          profile_after['profiles'].push('Box-score' => key, 'Record' => value)
        end
      rescue
        halt 404
      else
        profile_after
      end
    end

    def check_start_lineup(playernames,des)
      @lineup = { 'Description' => des }
      @body_null = true
      sean = Scraper.new
      # begin
      #   sean.profile(playernames)
      # rescue
      #   halt 404
      # end
      begin
        playernames == '' ? @body_null = false : @body_null = true
        fail 'err' if @body_null == false
      rescue
        halt 400
      end
      begin
        po = sean.game[0]
        s = sean.game[2]
        po.each do |key, _value|
          if key.include? 'PM'
            5.times do
              temp = s.shift
              playernames.each do |playername|
                lastname = playername.split(' ').last
                if temp.include?(lastname.capitalize)
                  @lineup[playername] = 'Yes, he is in start lineup today.'
                end
              end
            end
          else
            3.times { s.shift }
          end
        end
        playernames.each do |playername|
          unless @lineup.key?(playername)
            @lineup[playername] = 'No, he is not in start lineup today.'
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
    'Simple NBA catcher api/v1 is up and working!'
  end

  # namespace '/api/v1' do

  get '/api/v1/player/:playername.json' do
    content_type :json
    get_profile(params[:playername]).to_json
  end

  post '/api/v1/nbaplayers' do
    content_type :json
    begin
            req = JSON.parse(request.body.read)
            logger.info req
          rescue
            halt 400
          end
    nbaplayer = Nbaplayer.new
    nbaplayer.description = req['description'].to_json
    nbaplayer.playernames = req['playernames'].to_json

    if nbaplayer.save
      status 201
      redirect "api/v1/nbaplayers/#{nbaplayer.id}"
    end
  end

  get '/api/v1/nbaplayers/:id' do
    content_type :json
    begin
            @nbaplayer = Nbaplayer.find(params[:id])
            description = JSON.parse(@nbaplayer.description)
            playernames = JSON.parse(@nbaplayer.playernames)
            logger.info({ playernames: playernames }.to_json)
          rescue
            halt 400
          end

    check_start_lineup(playernames, description).to_json
  end
  # end
end
