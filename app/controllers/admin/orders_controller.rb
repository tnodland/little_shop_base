class Admin::OrdersController < Admin::BaseController
  def index
    user = User.find(params[:user_id])
    @orders = user.orders
    render :'/profile/orders/index'
  end
end