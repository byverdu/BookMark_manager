# Controller for home page

class Bookmark < Sinatra::Base

	get '/' do
		@links = Link.all
		erb :index
	end

end