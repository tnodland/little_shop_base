class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
  end

  def show
  end
end