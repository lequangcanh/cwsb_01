class Admin::VenuesController < Admin::BaseController

  def index
    @query_venues = Venue.includes(:address).ransack params[:q]
    @venues = @query_venues.result(distinct: true).order_created
      .page(params[:page]).per Settings.admin.venues.per_page

    respond_to do |format|
      format.html
      format.js
    end
  end  
end
