class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = User.find(params[:id])
    if @merchant.default?
      redirect_to admin_user_path(@merchant)
    else
      render :'/merchants/show'
    end
  end
end