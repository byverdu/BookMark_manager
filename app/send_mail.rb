require 'rest-client'
require_relative 'token'

module SendMail
    
    def email_confirmation(email,token)
      RestClient.post "https://api:#{Token::API_KEY}"\
      "@api.mailgun.net/v2/sandbox1dc7eee330cc42f2948b94e7cf7284a2.mailgun.org/messages",
      :from    => "Support@byverdu-bookmark.com",
      :to      => "#{email}",
      :subject => "Recovering email password",
      :text    => "Dear #{email}, use this link to reset your password \n 
                http://localhost:9292/users/reset_password/#{token}"
    end
end
