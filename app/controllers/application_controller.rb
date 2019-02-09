class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :current_reguser?, :current_merchant?, :current_admin?
  before_action :build_cart

  def build_cart
    @cart ||= Cart.new(session[:cart])
  end

  def current_user
    nil
  end

  def current_reguser?
    current_user && current_user.default?
  end

  def current_merchant?
    current_user && current_user.merchant?
  end

  def current_admin?
    current_user && current_user.admin?
  end

  def visitor_or_user
    render file: 'errors/not_found', status: 404 unless current_user.nil? || current_reguser?
  end

  def user_or_admin
    render file: 'errors/not_found', status: 404 unless current_user && (current_reguser? || current_admin?)
  end

  def require_user
    render file: 'errors/not_found', status: 404 unless current_reguser?
  end

  def require_merchant
    render file: 'errors/not_found', status: 404 unless current_merchant?
  end

  def require_admin
    render file: 'errors/not_found', status: 404 unless current_admin?
  end

end
