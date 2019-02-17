class Profile::OrdersController < ApplicationController
  before_action :user_or_admin

  def index
    @user = current_user
    @orders = Order.where(user: @user)
  end

  def create
    order = Order.create(user: current_user, status: :pending)
    @cart.items.each do |item|
      order.order_items.create!(
        item: item,
        price: item.price,
        quantity: @cart.count_of(item.id),
        fulfilled: false)
    end
    session[:cart] = nil

    flash[:success] = 'You have successfully checked out!'
    redirect_to profile_orders_path
  end
end