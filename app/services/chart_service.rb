class ChartService
  def initialize type, time, date_from = 0, date_to = 0, object = nil
    @type = type
    @time = time
    @date_from = date_from
    @date_to = date_to
    @object = object
  end

  def get_chart
    get_time
    get_type
  end

  private
  def set_chart_for_new_object class_name
    if @time == Settings.admin.new_statistics.this_year
      chart_data = data_of_this_year_for_new_object class_name
    else
      chart_data = data_of_duration_for_new_object class_name
    end
  end

  def data_of_this_year_for_new_object class_name
    chart_data = {}
    (Settings.chart_service.january..Settings.chart_service.december).each do |month|
      value = eval(class_name).number_record_in_month "#{month}/#{Date.today.year}".to_date
      chart_data["#{month}/#{Date.today.year}"] = value
    end
    chart_data
  end

  def data_of_duration_for_new_object class_name
    chart_data = {}
    data_from_model = eval(class_name).number_record_in_duration @date_from, @date_to
    data_from_model.transform_keys! {|key| key.to_date}
    (@date_from..@date_to).each do |date|
      if data_from_model.keys.include? date
        chart_data[date] = data_from_model[date]
      else
        chart_data[date] = 0
      end
    end
    chart_data
  end

  def get_time
    case @time
    when Settings.admin.new_statistics.this_week
      @date_from = Date.today.beginning_of_week
      @date_to = Date.today.end_of_week
    when Settings.admin.new_statistics.this_month
      @date_from = Date.today.beginning_of_month
      @date_to = Date.today.end_of_month
    end
  end

  def get_type
    case @type
    when Settings.admin.new_statistics.users
      set_chart_for_new_object User.name
    when Settings.admin.new_statistics.venues
      set_chart_for_new_object Venue.name
    when Settings.admin.new_statistics.spaces
      set_chart_for_new_object Space.name
    when Settings.chart_service.booking_of_venue
      set_chart_for_booking_of_venue @object
    when Settings.chart_service.revenue_of_venue
      set_chart_for_revenue_of_venue @object
    end
  end

  def set_chart_for_booking_of_venue object
    if @time == Settings.admin.new_statistics.this_year
      chart_data = data_of_this_year_for_booking_of_venue object
    else
      data_from_model = Booking.of_space_ids(Space.ids_of_venue object.id)
        .number_record_in_duration @date_from, @date_to
      chart_data = data_of_duration_for_venue data_from_model
    end
  end

  def set_chart_for_revenue_of_venue object
    if @time == Settings.admin.new_statistics.this_year
      chart_data = data_of_this_year_for_revenue_of_venue object
    else
      data_from_model = Order.created_in_duration(@date_from, @date_to)
        .group_created_at_by_date.total_revenue_of_venue object.id
      chart_data = data_of_duration_for_venue data_from_model
    end
  end

  def data_of_this_year_for_booking_of_venue object
    chart_data = {}
    (Settings.chart_service.january..Settings.chart_service.december).each do |month|
      value = Booking.of_space_ids(Space.ids_of_venue object.id)
        .number_record_in_month "#{month}/#{Date.today.year}".to_date
      chart_data["#{month}/#{Date.today.year}"] = value
    end
    chart_data
  end

  def data_of_this_year_for_revenue_of_venue object
    chart_data = {}
    (Settings.chart_service.january..Settings.chart_service.december).each do |month|
      value = Order.created_in_month("#{month}/#{Date.today.year}".to_date)
        .total_revenue_of_venue object.id
      chart_data["#{month}/#{Date.today.year}"] = value
    end
    chart_data
  end

  def data_of_duration_for_venue data_from_model
    chart_data = {}
    (@date_from..@date_to).each do |date|
      if data_from_model.keys.include? date
        chart_data[date] = data_from_model[date]
      else
        chart_data[date] = 0
      end
    end
    chart_data
  end
end
