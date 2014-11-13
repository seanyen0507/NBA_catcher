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

		post '/api/v1/check' do
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
	# end
end
