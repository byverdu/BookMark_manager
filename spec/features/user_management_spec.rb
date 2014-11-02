require_relative 'helpers/session'

include SessionHelpers

feature "User signs up" do

	scenario "when being logged out" do

		expect{ sign_up }.to change(User, :count).by(1)

		expect(page).to have_content("Welcome, alice@example.com")
		expect(User.first.email).to eq("alice@example.com")

	end

	feature "problems when singing up" do

		scenario "with an empty email field" do

			expect{ sign_up('', 'pass','pass') }.to change(User, :count).by(0)

			expect(page).to have_content('The email field must be filled')
		end

		scenario "the email must have a valid format" do
			expect{ sign_up('alice@example', 'pass','pass') }.to change(User, :count).by(0)

			expect(page).to have_content('The email must have a valid format')	
		end

		scenario "with an empty password field" do

			expect{ sign_up('alice@example.com', '','') }.to change(User, :count).by(0)

			expect(page).to have_content('The password field must be filled')
		end

		scenario "with a password that doesn't match" do

			expect{ sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
			expect(current_path).to eq('/users')
			expect(page).to have_content("Sorry, your passwords don't match")

		end

		scenario "with an email that is already registered" do 

			expect{ sign_up }.to change(User, :count).by(1)
			expect{ sign_up }.to change(User, :count).by(0)

			expect(page).to have_content("This email is already taken")
		end
  end
end



feature "User signs in" do
	
	before(:each) do
		User.create(email:   'test@test.com',
			    password: 'test',
			    password_confirmation: 'test')
	end

	scenario "with correct credentials" do

		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in('test@test.com', 'test')
		expect(page).to have_content("Welcome, test@test.com")
		
	end

	scenario "with incorrect credentials" do

		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in('test@test.com', 'wrong')
		expect(page).not_to have_content("Welcome, test@test.com")
		
	end

end

feature "Forgotten password" do

	before(:each) do
		User.create(email:   'test@test.com',
			    password: 'test',
			    password_confirmation: 'test',
			    password_token: 'newToken',
			    password_token_timestamp: Time.now)
	end

	scenario "Sending email to user" do

		visit '/sessions/new'

		expect(page).to have_content('Forgotten password?')
		click_link("Forgotten password?")
		expect(page.current_path).to eq '/users/reset_password'

		expect(page).to have_field("email")

		fill_in("email", with: "test@test.com" ) 

		click_button("Send")

		expect(page).to have_content("A confirmation email has been sent to your account")
	end

	scenario "resetting password" do

		visit "users/reset_password/newToken"

		expect(current_path).to eq("/users/confirm_password_reset")

		expect(page).to have_content("Please enter your new password test@test.com")

		fill_in "password",              with: 'test0'
		fill_in "password_confirmation", with: 'test0'

		click_button("Send")

		expect(page).to have_content("Your password has been changed")
	end

	scenario "the token can be used only for one hour" do

		User.create(email: 'alice@example.com',
			          password: 'test',
			          password_confirmation: 'test',
			          password_token: 'lastToken',
			          password_token_timestamp: Time.new(2014))

		visit "users/reset_password/lastToken"

		expect(page).to have_content("Your token has expired")

	end

end

feature "User signs out" do

	before(:each) do

		User.create( email:"test@test.com",
	                     password:"test",
			     password_confirmation: "test")
	end

	scenario "while being signed in" do
		sign_in("test@test.com", "test")

		click_button "Sign Out"

		expect(page).to     have_content("Good bye!")
		expect(page).not_to have_content("Welcome, test@test.com")
	end
end























