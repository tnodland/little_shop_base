require 'rails_helper'

RSpec.describe 'User Registration' do
  before :each do
    @name = 'Megan'
    @address = '310 Riverside Dr'
    @city = 'Fairfield'
    @state = 'OK'
    @zip = '52565'
    @email = 'megan@example.com'
    @password = 'supersecurepassword'
  end
  it 'should have form that creates new user' do
    visit registration_path

    fill_in :user_name, with: @name
    fill_in :user_email, with: @email
    fill_in :user_address, with: @address
    fill_in :user_city, with: @city
    fill_in :user_state, with: @state
    fill_in :user_zip, with: @zip
    fill_in :user_password, with: @password
    fill_in :user_password_confirmation, with: @password

    click_on 'Create User'

    new_user = User.last

    expect(current_path).to eq(profile_path)
    expect(page).to have_content("Welcome #{@name}, you are now registered and logged in.")
    expect(new_user.name).to eq(@name)
    expect(new_user.email).to eq(@email)
    expect(new_user.city).to eq(@city)
    expect(new_user.address).to eq(@address)
    expect(new_user.state).to eq(@state)
    expect(new_user.zip).to eq(@zip)
  end

  it 'renders new form and flash alert if required fields are missing' do
    visit registration_path

    click_on 'Create User'

    expect(page).to have_content("Required field(s) missing.")

    expect(page).to have_content("7 errors prohibited this user from being saved")
    expect(page).to have_content("Password can't be blank")
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Address can't be blank")
    expect(page).to have_content("City can't be blank")
    expect(page).to have_content("State can't be blank")
    expect(page).to have_content("Zip can't be blank")
    expect(page).to have_content("Email can't be blank")
  end

  it 'renders new form and flash alert if not all information is provided but re-populates fields' do
    visit registration_path

    fill_in :user_name, with: @name
    fill_in :user_email, with: @email
    fill_in :user_city, with: @city
    fill_in :user_state, with: @state
    fill_in :user_zip, with: @zip
    fill_in :user_password, with: @password
    fill_in :user_password_confirmation, with: @password

    click_on 'Create User'

    expect(find_field('Name').value).to eq(@name)
    expect(find_field('Email').value).to eq(@email)
    expect(find_field('City').value).to eq(@city)
    expect(find_field('State').value).to eq(@state)
    expect(find_field('Zip').value).to eq(@zip)
  end

  it 'renders new form and flash alert if email already exists' do
    user = create(:user, email: @email)

    visit registration_path

    fill_in :user_name, with: @name
    fill_in :user_email, with: user.email
    fill_in :user_address, with: @address
    fill_in :user_city, with: @city
    fill_in :user_state, with: @state
    fill_in :user_zip, with: @zip
    fill_in :user_password, with: @password
    fill_in :user_password_confirmation, with: @password

    click_on 'Create User'

    expect(page).to have_content("Email has already been taken")
    expect(find_field('Name').value).to eq(@name)
    expect(find_field('Email').value).to eq('')
    expect(find_field('Address').value).to eq(@address)
    expect(find_field('City').value).to eq(@city)
    expect(find_field('State').value).to eq(@state)
    expect(find_field('Zip').value).to eq(@zip)
  end
end
