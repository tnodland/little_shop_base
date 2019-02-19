require 'rails_helper'

include ActionView::Helpers::NumberHelper

RSpec.describe 'Merchant Dashboard Items page' do
  before :each do
    @merchant = create(:merchant)
    @admin = create(:admin)

    @items = create_list(:item, 3, user: @merchant)
    @items << create(:inactive_item, user: @merchant)

    @order = create(:completed_order)
    @oi_1 = create(:fulfilled_order_item, order: @order, item: @items[0], price: 1, quantity: 1, created_at: 2.hours.ago, updated_at: 50.minutes.ago)
  end

  describe 'should show all items and link to add more items' do
    scenario 'when logged in as merchant' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      @am_admin = false
      visit dashboard_path
    end
    after :each do
      click_link 'Items for Sale'
      if @am_admin
        # expect(current_path).to eq(admin_merchant_items_path(@merchant))
      else
        expect(current_path).to eq(dashboard_items_path)
      end

      expect(page).to have_link('Add new Item')

      @items.each_with_index do |item, index|
        within "#item-#{item.id}" do
          expect(page).to have_content("ID: #{item.id}")
          expect(page).to have_content("Name: #{item.name}")
          expect(page.find("#item-#{item.id}-image")['src']).to have_content(item.image)
          expect(page).to have_content("Price: #{number_to_currency(item.price)}")
          expect(page).to have_content("Inventory: #{item.inventory}")
          expect(page).to have_link('Edit Item')

          if index == 0
            expect(page).to_not have_button('Delete Item')
          else
            expect(page).to have_button('Delete Item')
          end
          if index != 3
            expect(page).to have_button('Disable Item')
            expect(page).to_not have_button('Enable Item')
          else
            expect(page).to have_button('Enable Item')
            expect(page).to_not have_button('Disable Item')
          end
        end
      end
    end
  end
end