class MerchantsController < ApplicationController
  before_action :require_merchant, only: [:show]

  def index
    @merchants = User.active_merchants
    @top_three_merchants = @merchants.top_merchants_by_revenue(3)
  end

  def show
  end
end
