class OrderHistoriesController < ApplicationController
  before_action :require_logged_in_user

  def index
    @orders = current_user.orders
      .recent.filter_by_payment_detail(params[:payment_detail_type])
      .filter_by_status(params[:status])
    respond_to do |format|
      format.html
      format.js
    end
  end
end
