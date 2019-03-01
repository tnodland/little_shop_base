require 'rails_helper'

RSpec.describe "coupon confirm" do
  describe "specs" do
    before :each do
      @merchant = create(:merchant)
      @item = create(:item, user: @merchant)
      @user = create(:user)
      @coupon = Coupon.create(code: "twentyfive", modifier: 0.75, user: @merchant, item: @item)
    end
    it "sees the info on the page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit cart_coupon_confirm_path

      expect(page).to have_content("Enter any coupons here")
      expect(page).to have_link("No coupons")
      expect(page).to have_content("Coupon code")

      click_link "No coupons"

      expect(current_path).to eq(cart_path)
    end

    it "can use a coupon" do
      item2 = create(:item, user: @merchant, price: 10)
      coupon2 = Coupon.create(code: "twenty", modifier: 0.8, user: @merchant, item: item2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit item_path(item2)
      click_button "Add to Cart"
      click_link "Cart: 1"

      fill_in "Coupon code", with: "twenty"
      click_button "Use this coupon"
      # save_and_open_page
      expect(current_path).to eq(cart_path)
      expect(page).to have_content("Total with coupon: $8")

      click_on 'Check out'

      expect(current_path).to eq(profile_orders_path)
    end
  end
end
