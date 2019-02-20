class Merchants::OrderItemsController < ApplicationController
  before_action :require_merchant

  def update
    oi = OrderItem.find(params[:id])
    oi.fulfill
    flash[:success] = "You have successfully fulfilled an item"
    redirect_to dashboard_order_path(oi.order)
  end
end
