module Admin::StatisticsHelper
  def get_choosen
    [{id: Settings.admin.new_statistics.users, value: t("admin.new_statistics.users")},
    {id: Settings.admin.new_statistics.venues, value: t("admin.new_statistics.venues")},
    {id: Settings.admin.new_statistics.spaces, value: t("admin.new_statistics.spaces")}]
  end

  def get_times
    [{id: Settings.admin.new_statistics.this_week, value: t("admin.new_statistics.this_week")},
    {id: Settings.admin.new_statistics.this_month, value: t("admin.new_statistics.this_month")}, 
    {id: Settings.admin.new_statistics.this_year, value: t("admin.new_statistics.this_year")},
    {id: Settings.admin.new_statistics.duration, value: t("admin.new_statistics.duration")}]
  end
end
