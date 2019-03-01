require 'rails_helper'

RSpec.describe Coupon do
  context "relationships" do
    it {should belong_to(:user)}
    it {should belong_to(:item)}
  end

  context "validations" do
    it {should validate_uniqueness_of :code}
    it {should validate_presence_of :modifier}
  end
end
