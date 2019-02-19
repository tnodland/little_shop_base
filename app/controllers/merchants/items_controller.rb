class Merchants::ItemsController < ApplicationController
  before_action :merchant_or_admin, only: [:index]

  def index
    @items = Item.where(user: current_user)
  end
end