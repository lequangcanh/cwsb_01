class UserPaymentBankingsController < ApplicationController
  before_action :load_order

  def create
    @user_payment_banking = UserPaymentBanking.new user_payment_banking_params
    if @user_payment_banking.save
      flash[:success] = t "booking_histories.choose_payment.success"
    else
      flash[:danger] = t "booking_histories.choose_payment.choose_payment_update.errors"
    end
    redirect_to order_histories_path
  end

  private

  def user_payment_banking_params
    params.require(:user_payment_banking).permit(:card_name, :card_number,
      :card_address, :banking_name, :email, :verified, :name).merge! order: @order
  end

  def load_order
    @order = Order.find_by id: params[:order_id]
    unless @order
      flash[:danger] = t "orders.errors.load"
      redirect_to booking_histories_path
    end
  end
end
