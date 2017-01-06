class Search::SpacesController < ApplicationController
  load_resource

  def index
    @addresses = Address.near params[:search], Settings.radius_search_in_miles
    if @addresses.present?
      @hash = mark_to_maps @addresses
    else
      @location = Geocoder.search(params[:search])
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @booking = Booking.new space: @space, booking_from: Date.today,
      duration: Settings.default_duration, quantity: Settings.default_quantity
    respond_to do |format|
      format.js
    end
  end
end
