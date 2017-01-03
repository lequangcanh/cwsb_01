class UserPaymentDirectliesController < ApplicationController
  before_action :load_order
  before_action :load_venue
  before_action :load_payment_directly
  before_action :load_directly

  def create
    @user_payment_directly = UserPaymentDirectly.new user_payment_directly_params
    if @user_payment_directly.save
      flash[:success] = "#{I18n.t "booking_histories.choose_payment.success"} #{
        I18n.t "booking_histories.choose_payment.notice_time"} #{@days} #{
        I18n.t "booking_histories.choose_payment.days"} #{@hours} #{
        I18n.t "booking_histories.choose_payment.hours"}"
    else
      flash[:danger] = t "booking_histories.choose_payment.choose_payment_update.errors"
    end
    redirect_to booking_histories_path
  end

  private
  def user_payment_directly_params
    params.require(:user_payment_directly).permit(:name, :email,:address, :phone, :verified)
      .merge! order: @order, user_id: current_user.id, pending_time: @directly.pending_time
  end

  def load_venue
    @venue = Venue.find_by id: params[:venue_id]
    unless @venue
      flash[:danger] = t "venue.not_found"
      redirect_to booking_histories_path
    end
  end

  def load_directly
    @directly = @venue.directly.find_by payment_method: @payment_directly
    if @directly
      @days = Common.convert_day @directly.pending_time
      @hours = Common.split_hour @directly.pending_time
    else
      flash[:danger] = t "booking_histories.choose_payment.directly_not_found"
      redirect_to booking_histories_path
    end
  end

  def load_payment_directly
    if @venue.payment_methods
      @payment_directly = @venue.payment_methods
        .find_by payment_type: Settings.payment_methods.directly
    else
      flash[:danger] = t "booking_histories.choose_payment.directly_not_found"
      redirect_to booking_histories_path
    end
  end

  def load_order
    @order = Order.find_by id: params[:order_id]
    unless @order
      flash[:danger] = t "orders.errors.load"
      redirect_to booking_histories_path
    end
  end
end
