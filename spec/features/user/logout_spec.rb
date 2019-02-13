require 'rails_helper'

RSpec.describe 'Log out workflow', type: :feature do
  it 'destroys their session tracking for user' do
    @user = create(:user, email:'user@gmail.com', password: 'password')

    visit login_path

    fill_in :email, with: @user.email
    fill_in :password, with: 'password'
    click_button 'Log in'

    within '.navbar-right' do
      click_link 'Log out'
    end

    expect(current_path).to eq(root_path)
    within '.navbar-right' do
      expect(page).to have_link('Log in')
      expect(page).to_not have_link('Log out')
    end
  end
end