require 'rails_helper'

RSpec.describe 'admin users index workflow' do
  before :each do
    @admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end
  describe 'shows basic information' do
    before :each do
      @active_users = create_list(:user, 3)
      @inactive_users = create_list(:inactive_user, 3)
      @merchants = create_list(:merchant, 3)
    end
    it 'should show users and not merchants' do
      visit admin_users_path

      @active_users.each do |user|
        within "#user-#{user.id}" do
          expect(page).to have_link(user.name)
          expect(page).to have_content("Registration Date: #{user.created_at}")
          expect(page).to have_button('Disable')
          expect(page).to_not have_button('Enable')
        end
      end
      @inactive_users.each do |user|
        within "#user-#{user.id}" do
          expect(page).to have_link(user.name)
          expect(page).to have_content("Registration Date: #{user.created_at}")
          expect(page).to_not have_button('Disable')
          expect(page).to have_button('Enable')
        end
      end
      @merchants.each do |merchant|
        expect(page).to_not have_css("#user-#{merchant.id}")
      end

      click_link @active_users[0].name
      expect(current_path).to eq(admin_user_path(@active_users[0]))
    end
  end
end