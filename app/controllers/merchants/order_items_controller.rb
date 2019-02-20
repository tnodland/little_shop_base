class Merchants::OrderItemsController < ApplicationController
  before_action :require_merchant

  def update
    oi = OrderItem.find(params[:id])
    oi.fulfill
    if oi.order.order_items.where(fulfilled: false).empty?
      oi.order.status = :completed
      oi.order.save
    end
    flash[:success] = "You have successfully fulfilled an item"
    redirect_to dashboard_order_path(oi.order)
  end
end
