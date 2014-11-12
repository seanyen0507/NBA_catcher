configure :development do
	set :database, 'sqlite3:db/dev.db'
	set :show_exceptions, true
end

configure :production do
	db = URI.parse(ENV['DATABASE'] || 'postgres:///lacalhost/mydb')

	ActiveRecord::Base.establish_connection(
		:adapter		=> db.scheme == 'postgres' ? 'postgresql' : db.scheme,
		:host		=> db.host,
		:username	=> db.user,
		:password 	=> db.password,
		:database 	=> db.path[1..-1],
		:encodeing 	=> 'utf8'
		)
end