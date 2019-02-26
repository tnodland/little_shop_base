class Merchants::CouponsController < ApplicationController
  before_action :merchant_or_admin, only: [:index]

  def index
    # binding.pry
    @merchant = User.find(params[:id])
  end
end
