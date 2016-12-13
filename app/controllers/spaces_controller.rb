class SpacesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_venue, except: :show
  before_action :load_booking_types, except: [:index, :show]
  load_and_authorize_resource

  def index
    @spaces = @venue.spaces
  end

  def new
    @space = Space.new
    build_resource
  end

  def create
    params["space"]["day_reject"] = Settings.day_reject if params["space"]["day_reject"].empty?
    @space = @venue.spaces.new space_params
    if @space.save
      flash[:success] = t ".create_success"
      redirect_to venue_spaces_path
    else
      flash[:danger] = t ".create_fail"
      render :new
    end
  end

  def edit
    @space.images.build if @space.images.blank?
  end

  def update
    if @space.update_attributes space_params
      flash[:success] = t ".update_success"
      redirect_to venue_spaces_path
    else
      flash[:danger] = t ".update_fail"
      render :edit
    end
  end

  def destroy
    @space.destroy
    respond_to do |format|
      format.js
    end
  end

  private
  def load_venue
    @venue = Venue.find_by id: params[:venue_id]
    if @venue.nil?
      flash[:danger] = t "venue.not_found"
      redirect_to venues_path
    end
  end

  def space_params
    params.require(:space).permit :name, :space_type, :area, :capicity, :quantity,
      :description, :day_reject, images_attributes: [:id, :picture],
      prices_attributes: [:id, :price, :booking_type_id]
  end

  def build_resource
    @space.images.build if @space.images.blank?
    @booking_types.each do |booking_type|
      @space.prices.build booking_type_id: booking_type.id
    end
  end

  def load_booking_types
    @booking_types = BookingType.all
  end
end
