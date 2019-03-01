class Profile::OrdersController < ApplicationController
  before_action :user_or_admin

  def index
    @user = current_user
    @orders = Order.where(user: @user)
  end

  def create
    unless params[:id].nil?
      @location = Location.find(params[:id])
    end

    if @location.nil?
      order = Order.create(user: current_user,
         status: :pending,
         user_address: current_user.address,
         user_city: current_user.city,
         user_state: current_user.state,
         user_zip: current_user.zip)
    else
      order = Order.create(user: current_user,
         status: :pending,
         user_address: @location.address,
         user_city: @location.city,
         user_state: @location.state,
         user_zip: @location.zip)
    end

    # if session[:coupons]
      # binding.pry
      # @cart.items.each do |item|
      #   order.order_items.create!(
      #     item: item,
      #     binding.pry
      #     price: item.price,
      #     # price: (item.final_price(@cart, session[:coupons])),
      #     quantity: @cart.count_of(item.id),
      #     fulfilled: false)
      # end
    # else
      @cart.items.each do |item|
        order.order_items.create!(
          item: item,
          price: item.price,
          quantity: @cart.count_of(item.id),
          fulfilled: false)
      end
    # end

    session[:cart] = nil
    session[:coupon] = nil
    flash[:success] = 'You have successfully checked out!'
    redirect_to profile_orders_path
  end

  def show
    @user = current_user
    @order = Order.find(params[:id])
    @locations = Location.where(user: current_user)
  end

  def update
    order = Order.find(params[:order])

    if params[:location].nil?
      order.update(user_address: current_user.address,
        user_city: current_user.city,
        user_state: current_user.state,
        user_zip: current_user.zip)
    else
      location = Location.find(params[:location])
      order.update(user_address: location.address,
        user_city: location.city,
        user_state: location.state,
        user_zip: location.zip)
    end

    redirect_to profile_order_path(order)
  end

  def destroy
    @order = Order.find(params[:id])

    @order.order_items.where(fulfilled: true).each do |oi|
      item = Item.find(oi.item_id)
      item.inventory += oi.quantity
      item.save
      oi.fulfilled = false
      oi.save
    end

    @order.status = :cancelled
    @order.save

    if current_reguser?
      redirect_to profile_orders_path
    elsif current_admin?
      redirect_to admin_user_orders_path(@order.user)
    end
  end
end
