require "sinatra/base"
require "data_mapper"

require_relative 'data_mapper_setup'
require_relative './helpers/application'


class Bookmark < Sinatra::Base

	include ApplicationHelpers

	set :views, File.join(root,'views')
	set :session_secret, 'super secret'
	
	enable :sessions
	

	get '/' do
		@links = Link.all

		erb :index
	end

	post '/links' do

		url   = params["url"]
		title = params["title"]

		tags  = params["tags"].split(", ").map do |tag|

			Tag.first_or_create(:text => tag)

		end

		Link.create(:url => url, :title => title, :tags => tags)

		redirect to('/')
	end


	get '/tags/:text' do

		tag    = Tag.first(:text => params[:text])
		@links = tag ? tag.links : []

		erb :index
	end


	get "/users/new" do

		erb :"users/new"
	end

	post '/users' do
		user = User.create(:email => params[:email],
								:password => params[:password])
		session[:user_id] = user.id
		redirect to('/')
	end

	
end