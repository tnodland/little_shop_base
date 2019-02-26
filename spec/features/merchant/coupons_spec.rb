require 'rails_helper'

RSpec.describe 'merchant coupons' do
  describe "index" do
    it "should see all coupons" do
      merchant = create(:merchant)
      item = create(:item, user: merchant)
      coupon = item.coupons.create(user: merchant, code: "coupon", modifier: 0.75)
      coupon2 = item.coupons.create(user: merchant, code: "coupon2", modifier: 1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
      
      visit dashboard_coupons_path(merchant)

      expect(page).to have_content("#{coupon.code}")
      expect(page).to have_content("#{coupon.modifier}")
      expect(page).to have_content("#{coupon2.code}")
    end
  end
end
