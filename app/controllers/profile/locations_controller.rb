class Profile::LocationsController < ApplicationController
  def index
    @user = current_user
    @locations = Location.where(user: @user)
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.create(location_params)
    @location.update(user: current_user)
    redirect_to profile_locations_path
  end

  private

  def location_params
    params.require(:location).permit(:address, :city, :state, :zip)
  end
end
