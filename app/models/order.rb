class Order < ApplicationRecord
  enum status: [:pending, :completed, :cancelled]

  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items

  validates_presence_of :status

  def total_item_count
    order_items.sum(:quantity)
  end

  def total_cost
    oi = order_items.pluck("sum(quantity*price)")
    oi.sum
  end

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

  def total_item_count
    order_items.sum(:quantity)
  end

  def total_cost
    oi = order_items.pluck("sum(quantity*price)")
    oi.sum
  end

  def self.top_orders_by_items_shipped(limit)
    sorted_by_items_shipped.limit(limit)
  end

  def self.sorted_by_items_shipped
    self.joins(:order_items)
        .select('orders.*, sum(order_items.quantity) as quantity')
        .where(status: 1, order_items: {fulfilled: true})
        .group(:id)
        .order('quantity desc')
  end

  def total_quantity_for_merchant(merchant_id)
    items.where('merchant_id = ?', merchant_id)
         .joins(:order_items).select('items.id, order_items.quantity')
         .distinct
         .sum('order_items.quantity')
  end

  def total_price_for_merchant(merchant_id)
    items.where('merchant_id = ?', merchant_id)
         .joins(:order_items).select('items.id, order_items.quantity, order_items.price')
         .distinct
         .sum('order_items.quantity*order_items.price')
  end

  def self.pending_orders_for_merchant(merchant_id)
    self.where(status: 0)
        .joins(:items)
        .where('items.merchant_id = ?', merchant_id)
        .distinct
  end
end
