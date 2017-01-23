class StatisticsController < ApplicationController
  before_action :find_venue, only: :create

  def index
    @venues = current_user.venues
  end

  def create
    time = statistics_params[:time]
    type = statistics_params[:type]
    date_from = statistics_params[:date_from]
    date_to = statistics_params[:date_to]
    respond_to do |format|
      if time == Settings.admin.new_statistics.duration
        set_chart_for_duration type, date_from, date_to, @venue
      else
        @chart = ChartService.new(type, time, 0, 0, @venue).get_chart
      end
      format.js
    end
  end

  private
  def statistics_params
    params.require(:statistics).permit :venue, :time, :type, :date_from, :date_to
  end

  def find_venue
    @venue = Venue.find_by id: statistics_params[:venue]
    unless @venue
      flash[:danger] = t "statistics.venue_not_found"
      redirect_to root_url
    end
  end

  def set_chart_for_duration type, date_from, date_to, venue
    if date_from.is_date? && date_to.is_date?     
      if date_from.to_date <= date_to.to_date
        @chart = ChartService.new(type, Settings.admin.new_statistics.duration, 
          date_from.to_date, date_to.to_date, venue).get_chart
      else
        flash.now[:danger] = t "admin.new_statistics.wrong_date"
      end
    else
      flash.now[:danger] = t "admin.new_statistics.invalid_date"
    end
  end
end
