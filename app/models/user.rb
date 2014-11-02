require "bcrypt"

class User

	include DataMapper::Resource

	property :id, Serial
	property :email, String, :unique => true, :format => :email_address, :messages => {:is_unique => "This email is already taken",
		    :format => "The email must have a valid format"}  
	property :password_digest, Text
	property :password_token, Text
	property :password_token_timestamp, Time

	attr_reader   :password
	attr_accessor :password_confirmation
	
	validates_confirmation_of :password, :message => "Sorry, your passwords don't match"
  validates_presence_of    :email, :message => "The email field must be filled"
  validates_length_of       :password, min: 1, message: "The password field must be filled"


	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

	def self.authenticate(email, password)
		user = first(email: email)
		if user && BCrypt::Password.new(user.password_digest) == password
			user
		else
			nil
		end
	end

end