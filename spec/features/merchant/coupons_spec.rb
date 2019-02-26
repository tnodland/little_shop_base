require 'rails_helper'

RSpec.describe 'merchant coupons' do
  describe "index" do
    before :each do
      @merchant = create(:merchant)
      @item = create(:item, user: @merchant)
      @coupon = @item.coupons.create(user: @merchant, code: "coupon", modifier: 0.75)
      @coupon2 = @item.coupons.create(user: @merchant, code: "coupon2", modifier: 1, active: false)

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

      visit dashboard_items_path
      within "#item-#{@item.id}" do
        expect(page).to have_link("Add a new coupon for this item")
        click_link "Add a new coupon for this item"
      end


      expect(current_path).to eq(dashboard_new_coupon_path(@item))
    end

    it "can create a new coupon" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      visit dashboard_new_coupon_path(@item)

      fill_in "Code", with: "twentyfive"
      fill_in "Modifier", with: 0.75

      click_on "Create Coupon"

      expect(current_path).to eq(dashboard_coupons_path(@merchant))
      expect(page).to have_content("twentyfive")
    end

    it "can a activate a coupon" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit dashboard_coupons_path(@merchant)

      within "#coupon-#{@coupon.id}" do
        expect(page).to_not have_link("Enable")
      end

      within "#coupon-#{@coupon2.id}" do
        expect(page).to have_link("Enable")
        click_link "Enable"
      end

      expect(current_path).to eq(dashboard_coupons_path(@merchant))

      within "#coupon-#{@coupon2.id}" do
        expect(page).to_not have_link("Enable")
      end
    end

    it "can disable a coupon" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit dashboard_coupons_path(@merchant)

      within "#coupon-#{@coupon2.id}" do
        expect(page).to_not have_link("Disable")
      end

      within "#coupon-#{@coupon.id}" do
        expect(page).to have_link("Disable")
        click_link "Disable"
      end

      expect(current_path).to eq(dashboard_coupons_path(@merchant))

      within "#coupon-#{@coupon.id}" do
        expect(page).to_not have_link("Disable")
      end
    end
  end
end
