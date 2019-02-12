class UsersController < ApplicationController
  before_action :require_user, only: [:show, :edit]

  def new
    @user = User.new
  end

  def show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome #{@user.name}, you are now registered and logged in."
      redirect_to profile_path
    else
      invalid_user(@user)
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)
    flash[:success] = "Your profile has been updated"
    redirect_to profile_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :address, :city, :state, :zip, :password)
  end

  def invalid_user(user)
    @user = user
    if User.find_by(email: @user.email)
      @user.email = ""
    else
      flash[:alert] = "Required field(s) missing."
    end
    render :new
  end
end
