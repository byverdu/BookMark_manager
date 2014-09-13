# Controller for adding links

class Bookmark < Sinatra::Base

	post '/links' do

		url   = params["url"]
		title = params["title"]

		tags  = params["tags"].split(", ").map do |tag|

			Tag.first_or_create(:text => tag)
		end

		Link.create(:url => url, :title => title, :tags => tags)

		redirect to('/')
	end
    
    get '/links/new' do
        erb :'links/new'    
    end
end	