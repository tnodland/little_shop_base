class Profile::OrdersController < ApplicationController
  before_action :user_or_admin

  def index
  end
end