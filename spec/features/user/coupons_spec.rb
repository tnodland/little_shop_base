require 'rails_helper'

RSpec.describe "coupon usage" do
  describe "as a user" do
    before :each do
      @user = create(:user)
      @merchant = create(:merchant)
      @item = create(:item, user: @merchant)
      @coupon = @item.coupons.create(user: @merchant, code: "twentyfive", modifier: 0.75)
    end

    it "sees a place to add a coupon" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit item_path(@item)

      click_on "Add to Cart"
      click_on "Cart: 1"

      within "#item-#{@item.id}" do
        expect(page).to have_content "Use a coupon for this item"
      end
    end

    it "can use a coupon" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit item_path(@item)

      click_on "Add to Cart"
      click_on "Cart: 1"
      within "#item-#{@item.id}" do
        fill_in :coupon_code, with: "twentyfive"
        click_on "Use this coupon"
      end

      expect(current_path).to eq(cart_path)
      within "#item-#{@item.id}" do
        expect(page).to have_content("Subtotal: $2.25")
      end
    end
  end
end
