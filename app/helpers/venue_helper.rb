module VenueHelper
  def label_status working_time
    if working_time.open?
      content_tag :label,
        class: "form-label status label label-primary label_#{working_time.id}" do
        working_time.status
      end
    else
      content_tag :label,
        class: "form-label status label label-danger label_#{working_time.id}" do
        working_time.status
      end
    end
  end

  def render_amenity_icon amenity
    case amenity.name
    when Settings.amenities.wifi
      "wifi"
    when Settings.amenities.restaurant
      "cutlery"
    when Settings.amenities.drink
      "coffee"
    when Settings.amenities.pet
      "paw"
    when Settings.amenities.lock
      "lock"
    end
  end

  def count_report object
    object.reports.count
  end
end
