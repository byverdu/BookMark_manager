require "sinatra/base"
require "data_mapper"

class Bookmark < Sinatra::Base

	env = ENV["RACK_ENV"] || "development"

	DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

	require './lib/link'

	DataMapper.finalize

	DataMapper.auto_upgrade!

	get '/' do
		'suck it sucker'
	end


end