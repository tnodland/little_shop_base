class Admin::ItemsController < Admin::BaseController
  def index
    @merchant = User.find(params[:merchant_id])
    @items = @merchant.items
    render :'/merchants/items/index'
  end

  def new
    @merchant = User.find(params[:merchant_id])
    @item = Item.new
    @form_path = [:admin, @merchant, @item]

    render "/merchants/items/new"
  end
end