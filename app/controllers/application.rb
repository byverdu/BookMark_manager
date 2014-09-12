
class Bookmark < Sinatra::Base

	#set :views, File.join(root,'views')

	get '/' do
		erb :index
	end

end