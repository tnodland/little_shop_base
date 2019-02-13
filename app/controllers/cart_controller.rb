class CartController < ApplicationController
  before_action :visitor_or_user
  include ActionView::Helpers::TextHelper

  def show
  end

  def add
    add_item_to_cart(params[:id])
    redirect_to items_path
  end

  private

  def add_item_to_cart(item_id)
    if item = Item.where(id: item_id).first
      @cart.add_item(item.id)
      flash[:success] = "You have #{pluralize(@cart.count_of(item.id), 'package')} of #{item.name} in your cart"
      session[:cart] = @cart.contents
    else
      flash[:error] = 'Cannot add that item'
    end
  end
end