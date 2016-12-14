class PaypalsController < ApplicationController
  protect_from_forgery except: :update

  before_action :load_order, only: :create
  before_action :load_paypal, only: :show
  before_action :load_payment_method, only: :create
  def create
    @paypal = Paypal.new order_id: @order.id, price: @order.total_paid, order: @order,
      payment_method_id: @payment_method.id
    if @paypal.save
      redirect_to @paypal.paypal_url paypal_path @paypal
    else
      flash[:danger] = t ".errors.load"
      redirect_to booking_histories_path
    end
  end

  def show
  end

  def update
    status = params[:payment_status]
    if status == Settings.complete_paypal_status
      @paypal = Paypal.find_by id: params[:invoice]
      if @paypal.update_attributes notification_params: notification_params,
        status: status, transaction_id: params[:txn_id], purchased_at: params[:payment_date],
        email: params[:payer_email], name: params[:first_name]
        flash[:success] = t "payment.success.update"
        @order = Order.find_by id: @paypal.order_id
        @order.update_attributes status: Order.statuses[:paid]
        unless @order
          flash[:danger] = t "payments.errors.load"
          redirect_to booking_histories_path
        end
      else
        flash[:danger] = t "payment.errors.update"
      end
    end
  end

  private
  def notification_params
    params.permit!
  end

  def load_order
    @order = Order.find_by id: params[:order]
    unless @order
      flash[:danger] = t "orders.errors.load"
      redirect_to booking_histories_path
    end
  end

  def load_paypal
    @paypal = Paypal.find_by id: params[:id]
    unless @paypal
      flash[:danger] = t "payments.errors.load"
      redirect_to booking_histories_path
    end
  end

  def load_payment_method
    @payment_method = @order.load_email_paypal
    unless @payment_method
      flash[:danger] = t "payments.errors.load"
      redirect_to booking_histories_path
    end
  end
end
