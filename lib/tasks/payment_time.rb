module PaymentTime
  def convert_day time
    time / 24
  end

  def split_hour time
    time % 24
  end

  def convert_hour days, hours
    days * 24 + hours
  end
end
