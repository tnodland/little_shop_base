class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = User.find(params[:id])
    if @merchant.default?
      redirect_to admin_user_path(@merchant)
    else
      render :'/merchants/show'
    end
  end

  def downgrade
    user = User.find(params[:id])
    user.role = :default
    user.save
    redirect_to merchants_path
  end


end