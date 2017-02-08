class Admin::VenuesController < Admin::BaseController
  before_action :find_venue, only: :update
  before_action :get_number_venues_block, only: :index
  def index
    @query_venues = Venue.includes(:address).ransack params[:q]
    @venues = @query_venues.result(distinct: true).order_created
      .page(params[:page]).per Settings.admin.venues.per_page
    @total_venue = Venue.count

    respond_to do |format|
      format.html
      format.js
    end
  end  

  def show
    @venue = Venue.find_by id: params[:id]
    return render file: Settings.admin.page_404_url unless @venue
    @spaces = @venue.spaces
  end

  def update
    respond_to do |format|
      if @venue.update_attributes venue_params
        get_number_venues_block
        format.json {render json: {message: t("success"), block_venue: @venue_block}}
      else
        format.json {render json: {message: t("failed")}}
      end
    end
  end
  
  private
  def venue_params
    params.require(:venue).permit :block
  end

  def find_venue
    @venue = Venue.find_by id: params[:id]
    unless @venue
      flash[:danger] = t "admin.venue.venue_not_found"
      redirect_to admin_venues_path
    end
  end

  def get_number_venues_block
    @venue_block = Venue.block_count
  end
end
