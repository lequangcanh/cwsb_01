class VenuesController < ApplicationController
  before_action :authenticate_user!
  load_resource

  def index
    @venues = current_user.venues
  end

  def new
    @venue = Venue.new
    @venue.build_address
  end

  def create
    @venue = Venue.new venue_params
    if @venue.save
      flash[:success] = t "flash.success_message"
      redirect_to edit_venue_path @venue
    else
      flash[:danger] = t "flash.danger_message"
      @venue.build_address
      render :new
    end
  end

  def show
  end

  def update
    authorize! :read, @venue
    if @venue.update_attributes venue_params
      flash[:success] = t "flash.success_detail"
      redirect_to edit_venue_path @venue, active: params[:detail]
    else
      flash[:danger] = t "flash.danger_message"
      @venue.build_address
      render :edit
    end
  end

  def edit
  end

  def destroy
    @venue.destroy
    respond_to do |format|
      format.js
    end
  end

  private
  def venue_params
    params.require(:venue).permit(:name, :description, :phone_number, :email,
      :website, address_attributes: [:details, :city, :postal_code, :street_address, :unit, :id])
      .merge! user: current_user
  end
end
