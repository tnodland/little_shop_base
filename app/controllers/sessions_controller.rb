class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      if @user.active?
        session[:user_id] = @user.id
        if current_reguser?
          redirect_to profile_path
        elsif current_merchant?
          redirect_to dashboard_path
        elsif current_admin?
          redirect_to admin_dashboard_index_path
        end
      else
        flash[:error] = 'Your account is inactive, contact an admin for help'
        render :new
      end
    else
      flash[:error] = 'Your credentials are bad and you should feel bad'
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end