require 'rails_helper'

RSpec.describe 'merchant coupons' do
  describe "index" do
    before :each do
      @merchant = create(:merchant)
      @item = create(:item, user: @merchant)
      @coupon = @item.coupons.create(user: @merchant, code: "test_coupon", modifier: 0.75)
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

    it "can't create a coupon with missing fields" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      visit dashboard_new_coupon_path(@item)

      fill_in "Code", with: "twentyfive"

      click_on "Create Coupon"

      expect(current_path).to eq(dashboard_new_coupon_path(@item))
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

    it "can update a coupon" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit dashboard_coupons_path(@merchant)

      within "#coupon-#{@coupon.id}" do
        expect(page).to have_link("Edit this coupon")
        click_link "Edit this coupon"
      end

      expect(current_path).to eq(dashboard_edit_coupon_path(@coupon))

      fill_in "Code", with: "twenty"
      fill_in "Modifier", with: 0.8

      click_on "Update Coupon"

      expect(current_path).to eq(dashboard_coupons_path(@merchant))
      within "#coupon-#{@coupon.id}" do
        expect(page).to have_content("twenty")
      end
    end

    it "can't update a coupon with missing fields" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit dashboard_edit_coupon_path(@coupon)

      fill_in "Code", with: ""
      fill_in "Modifier", with: 0.8
      click_on "Update Coupon"

      expect(current_path).to eq(dashboard_edit_coupon_path(@coupon))
    end

    it "can delete a coupon" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit dashboard_coupons_path(@merchant)

      within "#coupon-#{@coupon.id}" do
        expect(page).to have_link("Delete this coupon")
        click_link "Delete this coupon"
      end

      expect(current_path).to eq(dashboard_coupons_path(@merchant))
      expect(page).to_not have_content("#{@coupon.code}")
    end

    it "can't delete a coupon that has been used" do

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

    it "can only have 5 enabled coupons at once" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      coupon3 = @item.coupons.create(user: @merchant, code: "test_coupon3", modifier: 0.75)
      coupon4 = @item.coupons.create(user: @merchant, code: "test_coupon4", modifier: 0.75)
      coupon5 = @item.coupons.create(user: @merchant, code: "test_coupon5", modifier: 0.75)
      coupon6 = @item.coupons.create(user: @merchant, code: "test_coupon6", modifier: 0.75)

      visit dashboard_coupons_path(@merchant)

      within "#coupon-#{@coupon2.id}" do
        expect(page).to_not have_link("Enable")
      end
    end
  end
end
