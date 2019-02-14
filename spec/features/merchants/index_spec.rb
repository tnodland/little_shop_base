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
  end
end
