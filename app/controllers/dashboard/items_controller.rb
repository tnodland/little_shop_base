class Dashboard::ItemsController < ApplicationController
  before_action :require_merchant, only: [:index]

  def index
  end
end