class CouponsController < ApplicationController

  def confirm

  end

  def use
    @coupon = Coupon.find_by(code: params[:coupon_code])
    @items = @cart.items
    @reduced_item = Item.find(@coupon.item_id)
  end
end
