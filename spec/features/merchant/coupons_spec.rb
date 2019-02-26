require 'rails_helper'

RSpec.describe 'merchant coupons' do
  describe "index" do
    before :each do
      @merchant = create(:merchant)
      @item = create(:item, user: @merchant)
      @coupon = @item.coupons.create(user: @merchant, code: "coupon", modifier: 0.75)
      @coupon2 = @item.coupons.create(user: @merchant, code: "coupon2", modifier: 1)

    end
    it "should see all coupons" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit dashboard_coupons_path(@merchant)

      expect(page).to have_link("#{@coupon.code}")
      expect(page).to have_content("#{@coupon.modifier}")
      expect(page).to have_link("#{@coupon2.code}")

      click_link "#{@coupon.code}"

      expect(current_path).to eq(dashboard_coupon_path(@merchant))
    end

    it "should see a link to add a new coupon" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit dashboard_coupons_path(@merchant)

      expect(page).to have_link("Add a new coupon")

      click_link "Add a new coupon"

      expect(current_path).to eq(dashboard_new_coupon_path(@merchant))
    end
  end
end
