class MerchantsController < ApplicationController
  before_action :require_merchant, only: [:show]

  def index
  end

  def show
  end
end