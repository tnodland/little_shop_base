require 'rails_helper'

RSpec.describe Coupon do
  context "relationships" do
    it {should belong_to(:merchant)}
    it {should belong_to(:item)}
  end

  context "validations" do
    it {should validate_presence_of :code}
    it {should validate_presence_of :modifier}
  end
end
