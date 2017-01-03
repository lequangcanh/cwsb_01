class Common
  def self.convert_day time
    time / 24
  end

  def self.split_hour time
    time % 24
  end

  def self.convert_hour days, hours
    days * 24 + hours
  end
end
