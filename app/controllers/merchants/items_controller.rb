class Merchants::ItemsController < ApplicationController
  before_action :merchant_or_admin, only: [:index]

  def index
    @items = Item.where(user: current_user)
  end

  def enable
    set_item_active(true)
  end

  def disable
    set_item_active(false)
  end

  def destroy
    @item = Item.find(params[:id])
    merchant = @item.user
    if @item && @item.ever_ordered?
      flash[:error] = "Attempt to delete #{@item.name} was thwarted!"
    elsif @item
      @item.destroy
    end
    if current_admin?
      redirect_to admin_merchant_items_path(merchant)
    else
      redirect_to dashboard_items_path
    end
  end

  private

  def set_item_active(state)
    item = Item.find(params[:id])
    item.active = state
    item.save
    if current_admin?
      redirect_to admin_merchant_items_path(item.user)
    else
      redirect_to dashboard_items_path
    end
  end
end