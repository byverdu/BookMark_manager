class Bookmark < Sinatra::Base

	get "/users/new" do
		@user = User.new
		erb :"users/new"
	end

	post '/users' do
		@user = User.create(email:                 params[:email],
                        password:              params[:password],
				                password_confirmation: params[:password_confirmation])

		if @user.save
			session[:user_id]  = @user.id
			redirect to('/content')
		else
			flash.now[:errors] = @user.errors.full_messages
			erb :"users/new"
		end
	end

	
	get '/users/reset_password' do
		erb :"users/reset_password"
	end

	post '/users/reset_password' do
		email = params[:email]
		user  = User.first(:email => email)

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

		redirect to '/content'
	end
end