require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe 'relationships' do
    # as user
    it { should have_many :orders }
    it { should have_many(:order_items).through(:orders)}
    # as merchant
    it { should have_many :items }
  end

  describe 'class methods' do
    it ".active_merchants" do
      active_merchants = create_list(:merchant, 3)
      inactive_merchant = create(:inactive_merchant)

      expect(User.active_merchants).to eq(active_merchants)
    end

    describe "statistics" do
      before :each do
        u1 = create(:user, state: "CO")
        u2 = create(:user, state: "OK")
        u3 = create(:user, state: "IA")
        u4 = create(:user, state: "IA")
        u5 = create(:user, state: "IA")
        u6 = create(:user, state: "IA")
        @m1, @m2, @m3, @m4, @m5, @m6, @m7 = create_list(:merchant, 7)
        i1 = create(:item, merchant_id: @m1.id)
        i2 = create(:item, merchant_id: @m2.id)
        i3 = create(:item, merchant_id: @m3.id)
        i4 = create(:item, merchant_id: @m4.id)
        i5 = create(:item, merchant_id: @m5.id)
        i6 = create(:item, merchant_id: @m6.id)
        i7 = create(:item, merchant_id: @m7.id)
        o1 = create(:completed_order, user: u1)
        o2 = create(:cancelled_order, user: u1)
        o3 = create(:completed_order, user: u3)
        o4 = create(:completed_order, user: u2)
        o5 = create(:cancelled_order, user: u2)
        o6 = create(:completed_order, user: u3)
        o7 = create(:completed_order, user: u3)
        oi1 = create(:fulfilled_order_item, item: i1, order: o1, created_at: 1.days.ago)
        oi2 = create(:fulfilled_order_item, item: i2, order: o2, created_at: 7.days.ago)
        oi3 = create(:fulfilled_order_item, item: i3, order: o3, created_at: 6.days.ago)
        oi4 = create(:order_item, item: i4, order: o4, created_at: 4.days.ago)
        oi5 = create(:order_item, item: i5, order: o5, created_at: 5.days.ago)
        oi6 = create(:fulfilled_order_item, item: i6, order: o6, created_at: 3.days.ago)
        oi7 = create(:fulfilled_order_item, item: i7, order: o7, created_at: 2.days.ago)
      end
      it ".merchants_sorted_by_revenue" do
        expect(User.merchants_sorted_by_revenue.to_a).to eq([@m7, @m6, @m3, @m1])
      end

      it ".top_merchants_by_revenue()" do
        expect(User.top_merchants_by_revenue(3)).to eq([@m7, @m6, @m3])
      end

      it ".merchants_sorted_by_fulfillment_time" do
        expect(User.merchants_sorted_by_fulfillment_time.to_a).to eq([@m1, @m7, @m6, @m3])
      end

      it ".top_merchants_by_fulfillment_time" do
        expect(User.top_merchants_by_fulfillment_time(3)).to eq([@m1, @m7, @m6])
      end

      it ".bottom_merchants_by_fulfillment_time" do
        expect(User.bottom_merchants_by_fulfillment_time(3)).to eq([@m3, @m6, @m7])
      end

      it ".top_user_states_by_order_count" do
        expect(User.top_user_states_by_order_count(3).first.state).to eq("IA")
        expect(User.top_user_states_by_order_count(2).last.state).to eq("CO")
      end

      it ".top_user_city_by_order_count" do
        expect(User.top_user_states_by_order_count(3).first.state).to eq("Des Moines, IA")
        expect(User.top_user_states_by_order_count(2).last.state).to eq("Fairfield, CO")
      end
    end
  end

  describe 'instance methods' do
  end
end
