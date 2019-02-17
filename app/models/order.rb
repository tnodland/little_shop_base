class Order < ApplicationRecord
  enum status: [:pending, :completed, :cancelled]

  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items

  validates_presence_of :status

  def self.top_orders_by_items_shipped(limit)
    sorted_by_items_shipped.limit(limit)
  end

  def self.sorted_by_items_shipped
    self.where(status: 1)
        .joins(:order_items)
        .where('order_items.fulfilled = true')
        .group(:id)
        .select('orders.id, sum(order_items.quantity) AS quantity')
        .order('quantity DESC')
  end
end
