class Admin::ItemsController < Admin::BaseController
  def index
    merchant = User.find(params[:merchant_id])
    @items = merchant.items
    render :'/merchants/items/index'
  end
end