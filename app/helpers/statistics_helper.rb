module StatisticsHelper
  def get_types
    [{id: Settings.chart_service.booking_of_venue, value: t("statistics.booking_of_venue")},
    {id: Settings.chart_service.revenue_of_venue, value: t("statistics.revenue_of_venue")}]
  end
end
