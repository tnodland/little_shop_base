require 'rails_helper'

RSpec.describe 'user addresses' do
  describe 'address index'do
    before :each do
      @user = create(:user)
      @location = @user.locations.create(address: "1111 test street", city: "testville", state: "co", zip: 80111, name: "home")
      @merchant_1 = create(:merchant)
      @item_1 = create(:item, user: @merchant_1)
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

    it "can't create a location if fields are missing" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit new_profile_location_path

      fill_in "Address", with: "2222 test street"
      fill_in "City", with: "denver"
      fill_in "Zip", with: 11111

      click_on "Create Location"

      expect(current_path).to eq(new_profile_location_path)
    end

    it "can see a link to edit addresses" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_locations_path

      within "#locations-#{@location.id}" do
        expect(page).to have_link("Edit this address")
      end
    end

    it "can edit an address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_locations_path

      within "#locations-#{@location.id}" do
        click_link "Edit this address"
      end

      expect(current_path).to eq(edit_profile_location_path(@location))

      fill_in "Address", with: "2222 test street"
      fill_in "City", with: "denver"
      fill_in "State", with: "colorado"
      fill_in "Zip", with: 11111

      click_on "Update Location"

      expect(current_path).to eq(profile_locations_path)

      within "#locations-#{@location.id}" do
        expect(page).to have_content("2222 test street")
        expect(page).to have_content("denver")
        expect(page).to have_content("colorado")
        expect(page).to have_content(11111)
      end
    end

    it "cannot edit an address with missing info" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_locations_path

      within "#locations-#{@location.id}" do
        click_link "Edit this address"
      end

      expect(current_path).to eq(edit_profile_location_path(@location))

      fill_in "Address", with: "2222 test street"
      fill_in "City", with: "denver"
      fill_in "State", with: ""
      fill_in "Zip", with: 11111

      click_on "Update Location"

      expect(current_path).to eq(edit_profile_location_path(@location))
    end

    it "can delete an address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_locations_path

      within "#locations-#{@location.id}" do
        expect(page).to have_link("Delete this address")
        click_link "Delete this address"
      end

      expect(current_path).to eq(profile_locations_path)
      expect(page).to_not have_content("#{@location.address}")
    end

    it "can't delete an address that has been used in an order" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      order = create(:completed_order, user: @user, user_address: @location.address, user_state: @location.state, user_city: @location.city, user_zip: @location.zip)

      visit profile_locations_path

      within "#locations-#{@location.id}" do
        expect(page).to_not have_link("Delete this address")
      end
    end

    it "can swap main address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_locations_path

      within "#locations-#{@location.id}" do
        expect(page).to have_link("Make this your primary address")
        click_link "Make this your primary address"
      end

      expect(current_path).to eq(profile_locations_path)

      within "#home_address" do
        expect(page).to have_content(@location.address)
        expect(page).to have_content(@location.city)
        expect(page).to have_content(@location.state)
        expect(page).to have_content(@location.zip)
      end
    end
  end

  describe "checkout" do
    before :each do
      @user = create(:user)
      @location = @user.locations.create(address: "1111 test street", city: "testville", state: "co", zip: 80111, name: "home")
      @location2 = @user.locations.create(address: "2222 test street", city: "testville", state: "co", zip: 80111, name: "work")
      @merchant_1 = create(:merchant)
      @item_1 = create(:item, user: @merchant_1)
    end

    it "can select an address as checkout" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit items_path

      within "#item-#{@item_1.id}" do
        click_on "Add to Cart"
      end

      visit cart_path

      expect(page).to have_button("Check out with main address")
      expect(page).to have_button("Check out with #{@location.name} address")
      expect(page).to have_button("Check out with #{@location2.name} address")

      click_on "Check out with #{@location.name} address"

      expect(current_path).to eq(profile_orders_path)
      expect(page).to have_content("#{@location.address}")
    end

    it "can change the address of a pending order" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      order = create(:order, user: @user, user_address: @user.address, user_state: @user.state, user_city: @user.city, user_zip: @user.zip)

      visit profile_order_path(order)

      expect(page).to have_content("Ship to #{@location.address} #{@location.city}, #{@location.state} #{@location.zip} instead")

      click_link("Ship to #{@location.address} #{@location.city}, #{@location.state} #{@location.zip} instead")

      expect(current_path).to eq(profile_order_path(order))
      expect(page).to have_content("Shipping to: #{@location.address} #{@location.city}, #{@location.state} #{@location.zip}")
      expect(page).to_not have_link("Ship to #{@location.address} #{@location.city}, #{@location.state} #{@location.zip} instead")
    end

    it "can change the adress of a pending order to the main address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      order = create(:order, user: @user, user_address: @location.address, user_state: @location.state, user_city: @location.city, user_zip: @location.zip)

      visit profile_order_path(order)

      expect(page).to have_link("Ship to main address instead")
      click_link "Ship to main address instead"

      expect(current_path).to eq(profile_order_path(order))
      expect(page).to_not have_content("Ship to main address instead")
    end
  end
end
