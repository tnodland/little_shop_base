require 'rails_helper'

RSpec.describe 'login workflow' do
  describe 'visitors try to login' do
    context 'succeeds when credentials are correct' do
      scenario 'as a regular user' do
        @user = create(:user, email:'user@gmail.com', password: 'password')
      end
      scenario 'as a merchant user' do
        @user = create(:merchant, email:'user@gmail.com', password: 'password')
      end
      scenario 'as an admin user' do
        @user = create(:admin, email:'user@gmail.com', password: 'password')
      end
      after :each do
        visit login_path

        fill_in :email, with: @user.email
        fill_in :password, with: 'password'
        click_button 'Log in'
        if @user.default?
          expect(current_path).to eq(profile_path)
        elsif @user.merchant?
          expect(current_path).to eq(dashboard_path)
        elsif @user.admin?
          expect(current_path).to eq(admin_dashboard_index_path)
        end
      end
    end

    describe 'fails when credentials are incorrect' do
      before :each do
        @user = create(:user, email:'user@gmail.com', password: 'password')
        @error_msg = 'Your credentials are bad and you should feel bad'
      end
      scenario 'with empty form' do
        visit login_path
        click_button 'Log in'

        expect(current_path).to eq(login_path)
        expect(page).to have_content(@error_msg)
      end
      scenario 'with bad email' do
        visit login_path

        fill_in :email, with: 'bad@email.com'
        fill_in :password, with: 'password'
        click_button 'Log in'

        expect(current_path).to eq(login_path)
        expect(page).to have_content(@error_msg)
      end
      scenario 'with bad password' do
        visit login_path

        fill_in :email, with: @user.email
        fill_in :password, with: 'badpassword'
        click_button 'Log in'

        expect(current_path).to eq(login_path)
        expect(page).to have_content(@error_msg)
      end
    end

    it 'fails if user is inactive' do
      user = create(:inactive_user, email: 'user@gmail.com', password: 'password')
        visit login_path

        fill_in :email, with: user.email
        fill_in :password, with: 'password'
        click_button 'Log in'

        expect(current_path).to eq(login_path)
        expect(page).to have_content('Your account is inactive, contact an admin for help')
    end
  end
end