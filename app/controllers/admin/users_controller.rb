class Admin::UsersController < Admin::BaseController
  def index
    @users = User.where(role: 0).order(:name)
  end

  def show
    @user = User.find(params[:id])
  end

  def disable
    user = User.find(params[:id])
    set_active_flag(user, false)
    redirect_to admin_users_path
  end

  def enable
    user = User.find(params[:id])
    set_active_flag(user, true)
    redirect_to admin_users_path
  end

  private

  def set_active_flag(user, active_flag)
    user.active = active_flag
    user.save
  end
end
