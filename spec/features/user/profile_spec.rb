require 'rails_helper'

RSpec.describe 'user profile' do
  describe 'registered user visits their profile' do
    before :each do
      @user = create(:user)
    end

    it 'shows user information' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_path

      expect(page).to have_content("Name: #{@user.name}")
      expect(page).to have_content("Role: #{@user.role}")
      expect(page).to have_content("Email: #{@user.email}")
      expect(page).to have_content("Address: #{@user.address}")
      expect(page).to have_content("City: #{@user.city}")
      expect(page).to have_content("State: #{@user.state}")
      expect(page).to have_content("Zip: #{@user.zip}")
      expect(page).to have_link('Edit')
    end
  end
end
