class User < ApplicationRecord
  has_secure_password

  enum role: [:default, :merchant, :admin]

  # as a user
  has_many :orders
  has_many :order_items, through: :orders
  # as a merchant
  has_many :items, foreign_key: 'merchant_id'

  validates_presence_of :name, :address, :city, :state, :zip
  validates :email, presence: true, uniqueness: true

  def self.active_merchants
    where(role: "merchant", active: true)
  end

  def self.merchants_sorted_by_revenue
    # play around with hash notation
    self.joins(:items)
        .joins('join order_items on items.id = order_items.item_id')
        .joins('join orders on orders.id = order_items.order_id')
        .where('orders.status = 1')
        .where('order_items.fulfilled = true')
        .group(:id)
        .select('users.*, sum(order_items.quantity * order_items.price) AS total')
        .order("total DESC")
  end

  def self.top_merchants_by_revenue(limit)
    merchants_sorted_by_revenue.limit(limit)
  end
end
