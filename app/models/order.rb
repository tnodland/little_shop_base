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
end