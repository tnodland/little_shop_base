class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to profile_path
      flash[:success] = "Welcome #{@user.name}, you are now registered and logged in."
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :address, :city, :state, :zip, :password)
  end
end
