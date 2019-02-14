class MerchantsController < ApplicationController
  before_action :require_merchant, only: [:show]

  def index
    @merchants = User.active_merchants
  end

  def show
  end
end
