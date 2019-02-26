class Merchants::CouponsController < ApplicationController
  before_action :merchant_or_admin, only: [:index]

  def index
    @merchant = User.find(params[:id])
    @coupons = Coupon.where(user: @merchant)
  end
end
