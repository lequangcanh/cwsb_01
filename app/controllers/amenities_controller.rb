class AmenitiesController < ApplicationController
  before_action :load_venue, except: :update
  load_resource only: [:edit, :update, :destroy]

  def index
    @price_types = PriceType.all
  end

  def new
    @amenity = Amenity.new
    @amenity.build_service_charge
  end

  def create
    @amenity = Amenity.new amenity_params
    if @amenity.save
      flash[:success] = t "amenities.new.create_success"
      redirect_to venue_amenities_path
    else
      flash[:danger] = t "amenities.new.create_fail"
      render :new
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      @amenity.update_attributes amenity_params
      flash[:success] = t "amenities.new.edit_success"
      format.html {redirect_to venue_amenities_path}
      format.json do
        render json: {
          price: @amenity.service_charge.price,
          per: @amenity.service_charge.quantity,
          type: @amenity.service_charge.price_type.content
        }
      end
    end
  end

  def destroy
    if @amenity
      venue_amenity = @amenity.venue_amenities
        .find_by_amenity_and_venue @venue, @amenity
      if venue_amenity.destroy
        flash[:success] = t "amenities.destroy.delete_successfully"
      else
        flash[:danger] = t "amenities.destroy.delete_error"
      end
    end
    redirect_to venue_amenities_path
  end

  private

  def load_venue
    @venue = Venue.find_by id: params[:venue_id]
    if @venue.nil?
      flash[:danger] = t "venues.errors.load_fail"
      redirect_to root_url
    end
  end

  def amenity_params
    params.require(:amenity).permit(:name, :description,
      :quanity, :is_free,
      service_charge_attributes: [:price, :quantity, :price_type_id])
      .merge! venue: @venue
  end
end
