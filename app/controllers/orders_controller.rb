class OrdersController < ApplicationController
  def create
    respond_to do |format|
      @order = Order.new order_params
      if @order.save
        format.json {render json: {message: "success"}}
      else
        format.json {render json: {message: "failed"}}
      end
    end
  end

  private

  def order_params
    params.permit(:total_paid, :venue_id, :booking_ids).merge! user_id: current_user.id
  end
end
