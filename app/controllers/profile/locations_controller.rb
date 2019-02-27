class Profile::LocationsController < ApplicationController
  def index
    @user = current_user
    @locations = Location.where(user: @user)
  end
end
