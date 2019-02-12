require 'rails_helper'

RSpec.describe 'admin user show workflow' do
  before :each do
    @admin = create(:admin)
    @user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  it "should show user information" do
    visit admin_user_path(@user)

    expect(page).to have_content("Name: #{@user.name}")
    expect(page).to have_content("Role: #{@user.role}")
    expect(page).to have_content("Email: #{@user.email}")
    expect(page).to have_content("Address: #{@user.address}")
    expect(page).to have_content("City: #{@user.city}")
    expect(page).to have_content("State: #{@user.state}")
    expect(page).to have_content("Zip: #{@user.zip}")
  end
end
