class BankingsController < ApplicationController
  before_action :load_venue
  before_action :create_payment_method, only: :create
  before_action :load_banking, only: [:edit, :update]
  before_action :load_payment_method, only: [:edit, :update]

  def create
    @banking = Banking.new banking_params
    if @banking.save
      flash[:success] = t "payment_methods.create_success"
    else
      flash[:danger] = t "payment_methods.create_fail"
    end
    redirect_to edit_venue_venue_market_path
  end

  def edit
  end

  def update
    if @banking.update_attributes banking_params
      flash[:success] = t ".update_banking_success"
      redirect_to edit_venue_venue_market_path
    else
      flash[:danger] = t ".update_banking_fail"
      render :edit
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

  def load_banking
    @banking = Banking.find_by id: params[:id]
    unless @banking
      flash[:danger] = t "flash.danger_message"
      redirect_to edit_venue_venue_market_path
    end
  end

  def load_payment_method
    @payment_method = @venue.payment_methods.find_by payment_type: Settings.payment_methods.banking
    unless @payment_method
      flash[:danger] = t "flash.danger_message"
      redirect_to edit_venue_venue_market_path
    end
  end

  def create_payment_method
    @payment_method = @venue.payment_methods.new venue_id: @venue.id, payment_type: Settings.payment_methods.banking
    if @payment_method.save
      flash[:success] = t "venue_markets.create.success"
    else
      flash[:danger] = t "venue_markets.create.errors"
    end
  end

  def banking_params
    params.require(:banking).permit(:id, :card_name, :card_number,
      :card_address, :banking_name, :verified, :day, :hour, :message)
      .merge! payment_method: @payment_method,
      pending_time: Common.convert_hour(params[:banking][:day].to_i, params[:banking][:hour].to_i)
  end
end
