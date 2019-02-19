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

  def edit
    @merchant = User.find(params[:merchant_id])
    @item = Item.find(params[:id])
    @form_path = [:admin, @merchant, @item]

    render "/merchants/items/edit"
  end
end