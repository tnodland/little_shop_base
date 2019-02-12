require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :price }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of :description }
    it { should validate_presence_of :inventory }
    it { should validate_numericality_of(:inventory).only_integer }
    it { should validate_numericality_of(:inventory).is_greater_than_or_equal_to(0) }
  end

  describe 'relationships' do
    it { should belong_to :user }
    it { should have_many :order_items }
    it { should have_many(:orders).through(:order_items) }
  end

  describe 'instance methods' do
    describe '.avg_time_to_fulfill' do
      scenario 'happy path, with orders' do
        user = create(:user)
        merchant = create(:merchant)
        item = create(:item, user: merchant)
        order_1 = create(:completed_order, user: user)
        create(:fulfilled_order_item, order: order_1, item: item, quantity: 5, price: 2, created_at: 3.days.ago, updated_at: 1.day.ago)
        order_2 = create(:completed_order, user: user)
        create(:fulfilled_order_item, order: order_2, item: item, quantity: 5, price: 2, created_at: 1.days.ago, updated_at: 1.hour.ago)

        actual = item.avg_time_to_fulfill[0..13]
        expect(actual).to eq('1 day 11:30:00')
      end
      scenario 'sad path, no orders' do
        user = create(:user)
        merchant = create(:merchant)
        item = create(:item, user: merchant)

        expect(item.avg_time_to_fulfill).to eq('n/a')
      end
    end
  end
end