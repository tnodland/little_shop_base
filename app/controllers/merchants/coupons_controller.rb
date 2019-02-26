class Merchants::CouponsController < ApplicationController
  before_action :merchant_or_admin, only: [:index]

  def index
    @merchant = User.find(params[:id])
    @coupons = Coupon.where(user: @merchant)
  end

  def new
    @item = Item.find(params[:id])
    @merchant = User.find(@item.merchant_id)
    @coupon = Coupon.new(user: @merchant, item: @item)
  end

  def create
    @coupon = Coupon.create(coupon_params)
    @item = Item.find(params[:id])
    @merchant = User.find(@item.merchant_id)
    @coupon.update(item: @item)
    @coupon.update(user: @merchant)
    if @coupon.save
      redirect_to dashboard_coupons_path(@merchant)
    end
  end

  def enable
    @coupon = Coupon.find(params[:id])
    @coupon.update(active: true)
    @coupon.save
    @merchant = User.find(@coupon.user_id)
    redirect_to dashboard_coupons_path(@merchant)
  end

  def show

  end

  private

  def coupon_params
    params.require(:coupon).permit(:code, :modifier)
  end
end
