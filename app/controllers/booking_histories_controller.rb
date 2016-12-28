class BookingHistoriesController < ApplicationController
  before_action :require_logged_in_user

  def index
    current_bookings = current_user.bookings.have_order.with_deleted.recent
    @requests = current_bookings
      .group_by_order Booking.states.keys[Settings.requested]
    @accepts = current_bookings
      .group_by_order Booking.states.keys[Settings.accepted]
    @rejects = current_bookings
      .group_by_order Booking.states.keys[Settings.rejected]
  end
end
