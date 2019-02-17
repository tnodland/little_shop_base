require 'rails_helper'

include ActionView::Helpers::NumberHelper

RSpec.describe 'Profile Orders page', type: :feature do
  before :each do
    @user = create(:user)
    @admin = create(:admin)

    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @item_1 = create(:item, user: @merchant_1)
    @item_2 = create(:item, user: @merchant_2)
  end
  context 'as a registered user' do
    describe 'should show a message when user no orders' do
      scenario 'when logged in as user' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        visit profile_orders_path
      end
      after :each do
        expect(page).to have_content('You have no orders yet')
      end
    end

    describe 'should show information about each order when I do have orders' do
      before :each do
        yesterday = 1.day.ago
        @order = create(:order, user: @user, created_at: yesterday)
        @oi_1 = create(:order_item, order: @order, item: @item_1, price: 1, quantity: 1, created_at: yesterday, updated_at: yesterday)
        @oi_2 = create(:fulfilled_order_item, order: @order, item: @item_2, price: 2, quantity: 1, created_at: yesterday, updated_at: 2.hours.ago)
      end
      scenario 'when logged in as user' do
        @user.reload
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        visit profile_orders_path
      end
      after :each do
        expect(page).to_not have_content('You have no orders yet')

        within "#order-#{@order.id}" do
          expect(page).to have_link("Order ID #{@order.id}")
          expect(page).to have_content("Created: #{@order.created_at}")
          expect(page).to have_content("Last Update: #{@order.updated_at}")
          expect(page).to have_content("Status: #{@order.status}")
          expect(page).to have_content("Item Count: #{@order.total_item_count}")
          expect(page).to have_content("Total Cost: #{@order.total_cost}")
        end
      end
    end
  end
end