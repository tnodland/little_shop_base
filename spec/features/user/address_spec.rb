require 'rails_helper'

RSpec.describe 'user addresses' do
  describe 'address index'do
    before :each do
      @user = create(:user)
      @location = @user.locations.create(address: "1111 test street", city: "testville", state: "co", zip: 80111)
    end

    it "should see all addresses" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_locations_path

      within "#home_address" do
        expect(page).to have_content(@user.address)
        expect(page).to have_content(@user.city)
        expect(page).to have_content(@user.state)
        expect(page).to have_content(@user.zip)
      end

      within "#locations-#{@location.id}" do
        expect(page).to have_content(@location.address)
        expect(page).to have_content(@location.city)
        expect(page).to have_content(@location.state)
        expect(page).to have_content(@location.zip)
      end
    end

    it "should see a link to add a new address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_locations_path

      expect(page).to have_link("Add another address")
      click_on "Add another address"

      expect(current_path).to eq(new_profile_location_path)
    end
  end

  describe 'address new' do
    before :each do
      @user = create(:user)
      @location = @user.locations.create(address: "1111 test street", city: "testville", state: "co", zip: 80111)
    end

    it "can add a new address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit new_profile_location_path

      fill_in "Address", with: "2222 test street"
      fill_in "City", with: "denver"
      fill_in "State", with: "colorado"
      fill_in "Zip", with: 11111

      click_on "Create Location"

      expect(current_path).to eq(profile_locations_path)
      expect(page).to have_content("2222 test street")
      expect(page).to have_content("denver")
      expect(page).to have_content("colorado")
      expect(page).to have_content(11111)
    end
  end

  describe 'address show' do

  end
end
