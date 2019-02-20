class Merchants::OrdersController < ApplicationController
  before_action :require_merchant

  def show
    @merchant = current_user
    @order = Order.find(params[:id])
    @user = @order.user
    @order_items = @order.order_items_for_merchant(@merchant.id)
  end
end
