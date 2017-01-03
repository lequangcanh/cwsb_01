class Common
  class << self
    def convert_day time
      time / 24
    end

    def split_hour time
      time % 24
    end

    def convert_hour days, hours
      days * 24 + hours
    end

    def mul_60 hours
      hours * 60
    end
  end
end
