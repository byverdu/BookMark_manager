require 'mailgun'

module SendMail
    
    def email_confirmation(email,token)
      RestClient.post "https://api:key-532b956c162b4c69d03c7000d2c66d74@api.mailgun.net/v2/sandbox1dc7eee330cc42f2948b94e7cf7284a2.mailgun.org/messages",
      :from    => "Support@byverdu-bookmark.com",
      :to      => "#{email}",
      :subject => "Recovering email password",
      :text    => "Dear #{email}, use this link to reset your password \n 
                http://localhost:9292/users/reset_password/#{token}"
    end
end
