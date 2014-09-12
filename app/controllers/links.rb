class Bookmark < Sinatra::Base

	get '/content' do
		@links = Link.all

		erb :content
	end


	post '/links' do

		url   = params["url"]
		title = params["title"]

		tags  = params["tags"].split(", ").map do |tag|

			Tag.first_or_create(:text => tag)
		end

		Link.create(:url => url, :title => title, :tags => tags)

		redirect to('/content')
	end
end	