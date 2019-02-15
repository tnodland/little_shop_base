require 'rails_helper'

RSpec.describe "merchant index workflow", type: :feature do
  describe "As a visitor" do
    it "displays all active merchant information" do
      merchant_1, merchant_2 = create_list(:merchant, 2)
      inactive_merchant = create(:inactive_merchant)

      visit merchants_path

      within("#merchant-#{merchant_1.id}") do
        expect(page).to have_content(merchant_1.name)
        expect(page).to have_content("#{merchant_1.city}, #{merchant_1.state}")
        expect(page).to have_content("Registered Date: #{merchant_1.created_at}")
      end

      within("#merchant-#{merchant_2.id}") do
        expect(page).to have_content(merchant_2.name)
        expect(page).to have_content("#{merchant_2.city}, #{merchant_2.state}")
        expect(page).to have_content("Registered Date: #{merchant_2.created_at}")
      end

      expect(page).to_not have_content(inactive_merchant.name)
      expect(page).to_not have_content("#{inactive_merchant.city}, #{inactive_merchant.state}")
    end

    describe "shows merchant statistics" do
      before :each do
        @m1, @m2, @m3, @m4, @m5, @m6, @m7 = create_list(:merchant, 7)
        i1 = create(:item, merchant_id: @m1.id)
        i2 = create(:item, merchant_id: @m2.id)
        i3 = create(:item, merchant_id: @m3.id)
        i4 = create(:item, merchant_id: @m4.id)
        i5 = create(:item, merchant_id: @m5.id)
        i6 = create(:item, merchant_id: @m6.id)
        i7 = create(:item, merchant_id: @m7.id)
        o1 = create(:completed_order)
        o2 = create(:cancelled_order)
        o3 = create(:completed_order)
        o4 = create(:completed_order)
        o5 = create(:cancelled_order)
        o6 = create(:completed_order)
        o7 = create(:completed_order)
        oi1 = create(:fulfilled_order_item, item: i1, order: o1)
        oi2 = create(:fulfilled_order_item, item: i2, order: o2)
        oi3 = create(:fulfilled_order_item, item: i3, order: o3)
        oi4 = create(:order_item, item: i4, order: o4)
        oi5 = create(:order_item, item: i5, order: o5)
        oi6 = create(:fulfilled_order_item, item: i6, order: o6)
        oi7 = create(:fulfilled_order_item, item: i7, order: o7)
      end

      it "top 3 merchants by price and quantity, with their revenue" do
        visit merchants_path

        within("#top-three-merchants") do
          expect(page).to have_content("#{@m7.name}: $192.00")
          expect(page).to have_content("#{@m6.name}: $147.00")
          expect(page).to have_content("#{@m3.name}: $48.00")
        end
      end

      xit "top 3 merchants who were fastest at fulfilling items in an order, with their times" do

      end

      xit "worst 3 merchants who were slowest at fulfilling items in an order, with their times" do

      end

      xit "top 3 states where any orders were shipped, and count of orders" do

      end

      xit "top 3 cities where any orders were shipped, and count of orders" do

      end

      xit "top 3 orders by quantity of items shipped, plus their quantities" do

      end
    end
  end
end
