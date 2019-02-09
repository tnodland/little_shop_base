require 'rails_helper'

RSpec.describe Cart do
  describe 'instance methods' do
    it '.total_count' do
      cart = Cart.new({})
      expect(cart.total_item_count).to eq(0)
    end
  end
end
