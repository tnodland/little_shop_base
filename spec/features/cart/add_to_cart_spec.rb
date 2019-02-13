require 'rails_helper'

RSpec.describe 'cart workflow', type: :feature do
  before :each do
    @merchant = create(:merchant)
    @items = create_list(:item, 2, user: @merchant)
    @user = create(:user)
  end

  describe 'adding things to cart' do
    scenario 'as a visitor' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
    end
    scenario 'as a user' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end
    after :each do
      visit items_path
      within '.navbar' do
        expect(page).to have_content('Cart: 0')
      end

      within "#item-#{@items[0].id}" do
        click_button('Add to Cart')
      end
      within '.navbar' do
        expect(page).to have_content('Cart: 1')
      end
      expect(page).to have_content("You have 1 package of #{@items[0].name} in your cart")
      within "#item-#{@items[0].id}" do
        click_button('Add to Cart')
      end
      within '.navbar' do
        expect(page).to have_content('Cart: 2')
      end
      expect(page).to have_content("You have 2 packages of #{@items[0].name} in your cart")

      visit item_path(@items[1])
      click_button('Add to Cart')
      within '.navbar' do
        expect(page).to have_content('Cart: 3')
      end
      expect(page).to have_content("You have 1 package of #{@items[1].name} in your cart")
    end
  end

  describe 'some users cannot add to cart' do
    scenario 'as a merchant' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    end
    scenario 'as an admin' do
      admin = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    end
    after :each do
      visit items_path
      within "#item-#{@items[0].id}" do
        expect(page).to_not have_button('Add to Cart')
      end

      visit item_path(@items[1])
      expect(page).to_not have_button('Add to Cart')
    end
  end
end

RSpec.describe CartController, type: :controller do
  it 'redirects back to where you came from if you try to add an invalid item id to cart' do
    item = create(:item)
    put :add, params: {id: (item.id + 1)}
    expect(response.request.env['action_dispatch.request.flash_hash'].to_h['error']).to eq('Cannot add that item')
    expect(response.status).to eq(302)
    expect(response.header['Location']).to include(items_path)
  end
end