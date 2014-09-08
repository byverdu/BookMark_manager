class Link

	include DataMapper::Resource

	property :id, 				 Serial
	property :title, 			 String
	property :url,         String
	property :description, String
end