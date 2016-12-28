class ChartService
  def initialize type, time, date_from = 0, date_to = 0
    @type = type
    @time = time
    @date_from = date_from
    @date_to = date_to
  end

  def get_chart
    get_time
    get_type    
  end

  private
  def set_chart object
    if @time == Settings.admin.new_statistics.this_year
      chart_data = data_of_this_year object
    else
      chart_data = data_of_duration object
    end
  end

  def data_of_this_year object
    chart_data = {}
    (Settings.chart_service.january..Settings.chart_service.december).each do |month|
      value = eval(object).number_record_in_month "#{month}/#{Date.today.year}".to_date
      chart_data["#{month}/#{Date.today.year}"] = value
    end
    chart_data
  end

  def data_of_duration object
    chart_data = {}
    objects = eval(object).number_record_in_duration @date_from, @date_to
    objects.transform_keys! {|key| key.to_date}
    (@date_from..@date_to).each do |date|
      if objects.keys.include? date
        chart_data[date] = objects[date]
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
      set_chart User.name
    when Settings.admin.new_statistics.venues
      set_chart Venue.name
    when Settings.admin.new_statistics.spaces
      set_chart Space.name
    end
  end
end
