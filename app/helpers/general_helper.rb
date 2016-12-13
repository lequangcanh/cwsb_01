module GeneralHelper

  def first_active images, image
    return "active" if images.first == image
  end

  def mark_to_maps addresses
    hash = Gmaps4rails.build_markers(addresses) do |address, marker|
      marker.lat address.latitude
      marker.lng address.longitude
      marker.infowindow address.venue.try(:name)
    end
    hash
  end

  def require_logged_in_user
    unless user_signed_in?
      if request.xhr?
        render js: "window.location = '/users/sign_in'"
      else
        redirect_to new_user_session_path
      end
    end
  end

  def select_price space, booking_type_id
    space.prices.find_by_booking_type_id(booking_type_id).price
  end

  def display_state booking
    if booking.requested?
      Settings.span_warning
    elsif booking.accepted?
      Settings.span_success
    else
      Settings.span_danger
    end
  end

  def check_or_uncheck_checkbox booking_state
    if booking_state == "Rejected" || booking_state == "Pending"
      return false
    else
      return true
    end
  end

  def check_reject_or_accept booking
    case
    when booking.rejected?
      "rejected-#{booking.id}"
    when booking.accepted?
      "accepted-#{booking.id}"
    else
      "requested-#{booking.id}"
    end
  end

  def check_owner_existed venue
    if venue.user_role_venues.find_owner_role.size == Settings.owner_role_count
      t "disabled"
    end
  end
end
