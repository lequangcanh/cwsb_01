module RecordFindingByTime
  extend ActiveSupport::Concern

  included do
    scope :created_in_month, -> month do
      where created_at: month.beginning_of_month.midnight..month.end_of_month.end_of_day
    end

    scope :number_record_in_month, -> month do
      created_in_month(month).count
    end

    scope :created_in_duration, -> date_from, date_to do
      where created_at: date_from.midnight..date_to.end_of_day
    end

    scope :number_record_in_duration, -> date_from, date_to do
      created_in_duration(date_from, date_to).group("date(created_at)").count
    end
  end
end
