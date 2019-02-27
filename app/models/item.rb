class Item < ApplicationRecord
  belongs_to :user, foreign_key: 'merchant_id'
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :coupons
  has_many :coupon_users

  validates_presence_of :name, :description
  validates :price, presence: true, numericality: {
    only_integer: false,
    greater_than_or_equal_to: 0
  }
  validates :inventory, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  def avg_time_to_fulfill
    data = Item.joins(:order_items)
      .select("items.*, avg(order_items.updated_at - order_items.created_at) as avg_time")
      .where(id: self.id)
      .group(:id)
      .first
    unless data.nil?
      data.avg_time
    else
      'n/a'
    end
  end

  def self.item_popularity(limit, order)
    Item.joins(:order_items)
      .select('items.*, sum(quantity) as total_ordered')
      .group(:id)
      .order("total_ordered #{order}")
      .limit(limit)
  end

  def self.popular_items(limit)
    item_popularity(limit, :desc)
  end

  def self.unpopular_items(limit)
    item_popularity(limit, :asc)
  end

  def final_price(coupon)
    self.price * coupon.modifier
  end

  def ever_ordered?
    OrderItem.joins(:order)
      .where(fulfilled: true, orders: {status: :completed}, item_id: self.id)
      .count > 0
  end
end
