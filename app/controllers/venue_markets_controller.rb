class VenueMarketsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_venue, only: [:edit, :update]
  before_action :load_payment_type, only: :edit

  def edit
    @payment_method = @venue.payment_methods.new
    @directly = Directly.new unless @directly
    @payment_methods = @venue.payment_methods.order_by_payment_type
  end

  def update
    respond_to do |format|
      if @venue_market.validate venue_market_params
        @venue_market.save
        format.json {render json: {message: t("success")}}
        format.html {redirect_to :edit}
      else
        format.json {render json: {message: t("failed")}}
        format.html {redirect_to :edit}
      end
    end
  end

  private
  def load_venue
    @venue = Venue.find_by id: params[:venue_id]
    unless @venue
      flash[:danger] = t "flash.danger_message"
      redirect_to root_url
    end
    @venue_market = VenueMarketForm.new @venue
  end

  def venue_market_params
    params.require(:venue_market).permit(:slogan,
      :introduction, :status).merge! user: current_user
  end

  def load_payment_type
    @payment_methods = @venue.payment_methods
    @payment_directly = @payment_methods.find_by payment_type:
      Settings.payment_methods.directly
    @payment_banking = @payment_methods.find_by payment_type:
      Settings.payment_methods.banking
    @obj_banking = @venue.payment_methods.find_by payment_type: Settings.payment_methods.banking
    if @obj_banking
      @banking = Banking.find_by payment_method: @obj_banking
      unless @banking
        flash[:danger] = t "flash.danger_message"
        redirect_to venue_venue_market_path
      end
      @banking.day = Common.convert_day @banking.pending_time
      @banking.hour = Common.split_hour @banking.pending_time
    end
    if @payment_directly
      @directly = Directly.find_by payment_method: @payment_directly
      @directly.day = Common.convert_day @directly.pending_time
      @directly.hour = Common.split_hour @directly.pending_time
    end
  end
end
