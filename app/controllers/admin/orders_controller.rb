class Admin::OrdersController < Admin::BaseController
  def index
    user = User.find(params[:user_id])
    @orders = user.orders
    render :'/profile/orders/index'
  end
<<<<<<< HEAD

  def show
    @user = User.find(params[:user_id])
    @order = Order.find(params[:id])

    if @order.user_id != @user.id
      render file: 'errors/not_found', status: 404
    else
      render '/profile/orders/show'
    end
  end
=======
>>>>>>> 79e6da4... closes #52
end