feature "User browses the list of links" do

	before(:each) {

		Link.create(:url   => "http://makersacademy.com",
								:title => "Makers Academy")
		}

		scenario "When opening the home page" do
			visit '/'
			expect(page).to have_content("Makers Academy")
		end
end