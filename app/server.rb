=begin

Server file, all gems and files needed required in this location

=end

require "sinatra/base"
require "data_mapper"
require "rack-flash"
require 'sinatra/partial'

require_relative 'data_mapper_setup'   # App models inside this file 
require_relative 'helpers/application' # current_user helper
require_relative 'send_mail'  				 # mailgun 

require_relative './controllers/application'
require_relative './controllers/links'
require_relative './controllers/sessions'
require_relative './controllers/tags'
require_relative './controllers/users'


class Bookmark < Sinatra::Base

	register Sinatra::Partial

	include ApplicationHelpers
  include SendMail

	set :views, File.join(root, '..', 'views')
	set :session_secret, 'super secret'
	set :partial_template_engine, :erb
	
	enable :sessions

	use Rack::Flash
	use Rack::MethodOverride
end























