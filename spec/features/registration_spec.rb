require 'rails_helper'

RSpec.describe 'User Registration' do
  it 'should have form that creates new user' do
    visit registration_path

    fill_in "Name", with: "Megan"
    fill_in "Email", with: "megan@example.com"
    fill_in "Address", with: "310 Riverside Dr"
    fill_in "City", with: "Fairfield"
    fill_in "State", with: "OK"
    fill_in "Zip", with: "52565"
    fill_in "Password", with: "supersecurepassword"
    fill_in "Password confirmation", with: "supersecurepassword"

    click_on 'Create User'

    new_user = User.last

    expect(current_path).to eq(profile_path)
    expect(page).to have_content("Welcome #{new_user.name}, you are now registered and logged in.")
    expect(new_user.name).to eq("Megan")
    expect(new_user.email).to eq("megan@example.com")
    expect(new_user.city).to eq("Fairfield")
    expect(new_user.address).to eq("310 Riverside Dr")
    expect(new_user.state).to eq("OK")
    expect(new_user.zip).to eq("52565")
  end

  it 'renders new form and flash alert if not all information is provided' do
    visit registration_path

    fill_in "Name", with: "Megan"
    fill_in "Email", with: "megan@example.com"
    fill_in "City", with: "Fairfield"
    fill_in "State", with: "OK"
    fill_in "Zip", with: "52565"
    fill_in "Password", with: "supersecurepassword"
    fill_in "Password confirmation", with: "supersecurepassword"

    click_on 'Create User'

    expect(page).to have_content("Required field(s) missing.")
    expect(find_field('Name').value).to eq('Megan')
    expect(find_field('Email').value).to eq('megan@example.com')
    expect(find_field('City').value).to eq('Fairfield')
    expect(find_field('State').value).to eq('OK')
    expect(find_field('Zip').value).to eq('52565')
  end

  it 'renders new form and flash alert if email already exists' do
    create(:user, email: "megan@example.com")

    visit registration_path

    fill_in "Name", with: "Megan"
    fill_in "Email", with: "megan@example.com"
    fill_in "Address", with: "310 Riverside Dr"
    fill_in "City", with: "Fairfield"
    fill_in "State", with: "OK"
    fill_in "Zip", with: "52565"
    fill_in "Password", with: "supersecurepassword"
    fill_in "Password confirmation", with: "supersecurepassword"

    click_on 'Create User'

    expect(page).to have_content("Email is already in use.")
    expect(find_field('Name').value).to eq('Megan')
    expect(find_field('Email').value).to eq('')
    expect(find_field('Address').value).to eq('310 Riverside Dr')
    expect(find_field('City').value).to eq('Fairfield')
    expect(find_field('State').value).to eq('OK')
    expect(find_field('Zip').value).to eq('52565')
  end
end
