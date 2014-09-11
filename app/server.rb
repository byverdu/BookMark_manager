require "sinatra/base"
require "data_mapper"
require "rack-flash"

require_relative 'data_mapper_setup'
require_relative 'helpers/application'
require_relative 'send_mail'


class Bookmark < Sinatra::Base

	include ApplicationHelpers
    include SendMail

	set :views, File.join(root,'views')
	set :session_secret, 'super secret'
	
	enable :sessions

	use Rack::Flash
	use Rack::MethodOverride

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
		@user = User.new
		erb :"users/new"
	end

	post '/users' do
		@user = User.create(email:                 params[:email],
                            password:              params[:password],
				            password_confirmation: params[:password_confirmation])

		if @user.save
			session[:user_id] = @user.id
			redirect to('/')
		else
			flash.now[:errors] = @user.errors.full_messages
			erb :"users/new"
		end
	end

	get '/sessions/new' do
		erb :"sessions/new"
	end


	post '/sessions' do

		email, password = params[:email], params[:password]

		user = User.authenticate(email, password)

		if user
			session[:user_id] = user.id
			redirect to '/'
		else
			flash[:errors]    = ["The email or password is incorrect"]
			erb :"sessions/new"
		end
	end	

	delete '/sessions' do

		flash[:notice]    = "Good bye!"
		session[:user_id] = nil

		redirect to '/sessions/new'
	end

	get '/users/reset_password' do
		erb :"users/reset_password"
	end

	post '/users/reset_password' do
		email = params[:email]
		user = User.first(:email => email)

		if !user.nil?
			user.password_token           = (1..64).map { ('A'..'Z').to_a.sample }.join
			user.password_token_timestamp = Time.now
			user.save
            
      email_confirmation(email,user.password_token)
            
			flash[:notice] = "A confirmation email has been sent to your account"
			redirect to '/sessions/new'
		else
			flash[:errors] = ["This email has not been registered"]
			erb :"sessions/new"
		end

	end

	get '/users/reset_password/:token' do |token|
		user = User.first(:password_token => token)
		session[:user_id] = user.id

		if (Time.now - user.password_token_timestamp) > 3600
			flash[:errors] = ["Your token has expired"]
			redirect to '/users/reset_password'
		else
			redirect to '/users/confirm_password_reset'
		end
	end

	get '/users/confirm_password_reset' do
		@user = User.first(:id => session[:user_id])
		if (Time.now - @user.password_token_timestamp) > 3600
			flash[:errors] = ["Your token has expired"]
			redirect to '/users/reset_password'
		else
			erb :"users/confirm_password_reset"
		end
	end

	post '/users/confirm_password_reset' do

		user = User.first(:password_token => params[:password_token])
		user.password              = params[:password]
		user.password_confirmation = params[:password_confirmation]
		user.save!
		
		flash[:notice]             = "Your password has been changed"

		redirect to '/'
	end
end























