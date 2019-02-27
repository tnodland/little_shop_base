require 'rails_helper'

RSpec.describe 'user profile', type: :feature do
  before :each do
    @user = create(:user)
  end

  describe 'registered user visits their profile' do
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
    describe 'user profile may or may not show a link to see orders' do
      it 'hides the link if user has no orders' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        expect(page).to_not have_link('See all Orders')
      end
      it 'shows the link if user has orders' do
        create(:order, user: @user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

        visit profile_path

        expect(page).to have_link('See all Orders')
      end
    end
  end

  describe 'registered user edits their profile' do
    describe 'edit user form' do
      it 'pre fills form with all but password information' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

        visit profile_path

        click_link 'Edit'

        expect(current_path).to eq('/profile/edit')
        expect(find_field('Name').value).to eq(@user.name)
        expect(find_field('Email').value).to eq(@user.email)
        expect(find_field('Address').value).to eq(@user.address)
        expect(find_field('City').value).to eq(@user.city)
        expect(find_field('State').value).to eq(@user.state)
        expect(find_field('Zip').value).to eq(@user.zip)
        expect(find_field('Password').value).to eq(nil)
        expect(find_field('Password confirmation').value).to eq(nil)
      end
    end

    describe 'user information is updated' do
      before :each do
        @updated_name = 'Updated Name'
        @updated_email = 'updated_email@example.com'
        @updated_address = 'newest address'
        @updated_city = 'new new york'
        @updated_state = 'S. California'
        @updated_zip = '33333'
        @updated_password = 'newandextrasecure'
      end
      describe 'succeeds with allowable updates' do
        it 'all attributes are updated' do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
          old_digest = @user.password_digest

          visit edit_profile_path

          fill_in :user_name, with: @updated_name
          fill_in :user_email, with: @updated_email
          fill_in :user_address, with: @updated_address
          fill_in :user_city, with: @updated_city
          fill_in :user_state, with: @updated_state
          fill_in :user_zip, with: @updated_zip
          fill_in :user_password, with: @updated_password
          fill_in :user_password_confirmation, with: @updated_password

          click_button 'Update User'

          updated_user = User.find_by(email: @user.email)

          expect(current_path).to eq(profile_path)
          expect(page).to have_content("Your profile has been updated")
          expect(page).to have_content("Name: #{@updated_name}")
          expect(page).to have_content("Email: #{@updated_email}")
          expect(page).to have_content("Address: #{@updated_address}")
          expect(page).to have_content("City: #{@updated_city}")
          expect(page).to have_content("State: #{@updated_state}")
          expect(page).to have_content("Zip: #{@updated_zip}")
          expect(updated_user.password_digest).to_not eq(old_digest)
        end
      end
    end

    it 'fails with non-unique email address change' do
      create(:user, email: 'megan@example.com')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit edit_profile_path

      fill_in :user_email, with: 'megan@example.com'

      click_button 'Update User'

      expect(page).to have_content("That email address is already in use")
    end

    it "sees a link to manage addresses" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_path

      expect(page).to have_link("Manage Addresses")
      click_link "Manage Addresses"

      expect(current_path).to eq(profile_locations_path)
    end
  end
end
