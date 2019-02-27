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
    if @location.save
      redirect_to profile_locations_path
    else
      redirect_to new_profile_location_path
    end
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    @location.update(location_params)
    if @location.save
      redirect_to profile_locations_path
    else
      redirect_to edit_profile_location_path(@location)
    end
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    redirect_to profile_locations_path
  end

  def main
    @user = current_user
    @location = Location.find(params[:id])
    @location2 = Location.create(user: @user,
            address: @user.address,
            city: @user.city,
            state: @user.state,
            zip: @user.zip)

    @user.update(address: @location.address,
                city: @location.city,
                state: @location.state,
                zip: @location.zip)

    @location.destroy
    redirect_to profile_locations_path
  end

  private

  def location_params
    params.require(:location).permit(:address, :city, :state, :zip)
  end
end
