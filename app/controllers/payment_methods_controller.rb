class PaymentMethodsController < ApplicationController
  before_action :load_venue
  before_action :load_payment_method, only: [:destroy, :update]
  before_action :load_is_chosen_paypal, only: [:update, :create]
  before_action :load_payment_directly, only: :destroy

  def index
    @payment_methods = @venue.payment_methods
  end

  def new
    @payment_method = @venue.payment_methods.new
  end

  def create
    @payment_method = @venue.payment_methods.new payment_method_params
    respond_to do |format|
      @payment_method.save
      format.js
    end
    if @payment_method.paypal? && @chosen_paypal
      @chosen_paypal.update_attributes is_chosen: false
    end
  end

  def update
    @payment_methods = @venue.payment_methods
    respond_to do |format|
      if @payment_method.update_attributes is_chosen: !@payment_method.is_chosen
        if @chosen_paypal
          @chosen_paypal.update_attributes is_chosen: false
        end
        format.json {render json: {flash: I18n.t("payment_methods.update_paypal_success"), check_update: 1 }}
      else
        format.json {render json: {flash: I18n.t("payment_methods.update_paypal_fail")}}
      end
    end
  end

  def destroy
    if @payment_method.destroy
      flash[:success] = t ".delete_successfully"
    else
      flash[:alert] = t ".delete_error"
    end
    redirect_to edit_venue_venue_market_path
  end

  private
  def payment_method_params
    params.require(:payment_method).permit :venue_id, :payment_type, :email, :is_chosen
  end

  def load_payment_method
    @payment_method = @venue.payment_methods.find_by id: params[:id]
    unless @payment_method
      flash[:danger] = t ".not_found"
      redirect_to edit_venue_venue_market_path
    end
  end

  def load_venue
    @venue = Venue.find_by id: params[:venue_id]
    unless @venue
      flash[:danger] = t "venue.not_found"
      redirect_to venues_path
    end
  end

  def load_is_chosen_paypal
    @chosen_paypal = @venue.payment_methods.paypal.find_by is_chosen: true
  end

  def load_payment_directly
    @directly = Directly.find_by payment_method: @payment_method
  end
end
