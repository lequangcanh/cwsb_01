class Admin::StatisticsController < Admin::BaseController
  def index
    @chart = ChartService.new(Settings.admin.new_statistics.users,
      Settings.admin.new_statistics.this_week).get_chart
    @space_count_of_venue = Venue.count_spaces
    @space_count_of_venue_chart = count_values @space_count_of_venue
    @booking_count_of_space = Space.count_bookings
    @booking_count_of_space_chart = count_values @booking_count_of_space
  end

  def create
    respond_to do |format|
      choosen = statistics_params[:choosen]
      times = statistics_params[:times]
      date_from = statistics_params[:date_from]
      date_to = statistics_params[:date_to]
      if times == Settings.admin.new_statistics.duration
        set_chart_for_duration choosen, date_from, date_to
      else
        @chart = ChartService.new(choosen, times).get_chart
      end
      format.js
    end
  end

  private
  def statistics_params
    params.require(:new_statistics).permit :choosen, :times, :date_from, :date_to
  end

  def set_chart_for_duration choosen, date_from, date_to
    if date_from.is_date? && date_to.is_date?     
      if date_from.to_date <= date_to.to_date
        @chart = ChartService.new(choosen, Settings.admin.new_statistics.duration, 
          date_from.to_date, date_to.to_date).get_chart
      else
        flash.now[:danger] = t "admin.new_statistics.wrong_date"
      end
    else
      flash.now[:danger] = t "admin.new_statistics.invalid_date"
    end
  end

  def count_values object
    object.collect{|t| {"#{t.name}": t.quantities}}.reduce Hash.new, :merge  
  end
end
