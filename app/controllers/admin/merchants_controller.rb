class Admin::MerchantsController < Admin::BaseController
  def show
    @user = User.find(params[:id])
    if @user.default?
      redirect_to admin_user_path(@user)
    end
  end
end