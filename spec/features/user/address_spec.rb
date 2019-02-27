require 'rails_helper'

RSpec.describe 'user addresses' do
  describe 'address index'do
    it "should see all addresses" do
      user = create(:user)
      location = user.locations.create(address: "1111 test street", city: "testville", state: "co", zip: 80111)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_locations_path

      within "#home_address" do
        expect(page).to have_content(user.address)
        expect(page).to have_content(user.city)
        expect(page).to have_content(user.state)
        expect(page).to have_content(user.zip)
      end

      within "#locations-#{location.id}" do
        expect(page).to have_content(location.address)
        expect(page).to have_content(location.city)
        expect(page).to have_content(location.state)
        expect(page).to have_content(location.zip)
      end
    end
  end

  describe 'address show' do

  end
end
