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

      visit coupon_confirm_path

      expect(page).to have_content("Enter any coupons here")
      expect(page).to have_link("No coupons")
      expect(page).to have_content("Coupon code")

      click_link "No coupons"

      expect(current_path).to eq(cart_path)
    end
  end
end
