class UserPaymentBankingsController < ApplicationController
  include PaymentTime
  before_action :load_order
  before_action :load_venue
  before_action :load_payment_banking
  before_action :load_banking

  def create
    @user_payment_banking = UserPaymentBanking.new user_payment_banking_params
    if @user_payment_banking.save
      flash[:success] = "#{I18n.t "booking_histories.choose_payment.success"} #{
        I18n.t "booking_histories.choose_payment.notice_time"} #{@days} #{
        I18n.t "booking_histories.choose_payment.days"} #{@hours} #{
        I18n.t "booking_histories.choose_payment.hours"}"
    else
      flash[:danger] = t "booking_histories.choose_payment.choose_payment_update.errors"
    end
    redirect_to order_histories_path
  end

  private
  def user_payment_banking_params
    params.require(:user_payment_banking).permit(:card_name, :card_number,
      :card_address, :banking_name, :email, :verified, :name)
      .merge! order: @order, user_id: current_user.id, pending_time: @banking.pending_time
  end

  def load_order
    @order = Order.find_by id: params[:order_id]
    unless @order
      flash[:danger] = t "orders.errors.load"
      redirect_to booking_histories_path
    end
  end

  def load_banking
    @banking = @venue.banking.find_by payment_method: @payment_banking
    if @banking
      @days = convert_day @banking.pending_time
      @hours = split_hour @banking.pending_time
    else
      flash[:danger] = t "booking_histories.choose_payment.banking_not_found"
      redirect_to booking_histories_path
    end
  end

  def load_payment_banking
    if @venue.payment_methods
      @payment_banking = @venue.payment_methods.find_by payment_type: Settings.payment_methods.banking
    else
      flash[:danger] = t "booking_histories.choose_payment.banking_not_found"
      redirect_to booking_histories_path
    end
  end

  def load_venue
    @venue = Venue.find_by id: params[:venue_id]
    unless @venue
      flash[:danger] = t "venue.not_found"
      redirect_to booking_histories_path
    end
  end
end
