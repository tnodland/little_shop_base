require 'rails_helper'

RSpec.describe Location, type: :model do
  describe "validations" do
    it {should validate_presence_of :address}
  end

  describe "relationships" do
    it {should belong_to :user}
  end
end
