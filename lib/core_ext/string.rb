class String
  def is_date?
    begin
      return true if self.to_date
      return false
    rescue ArgumentError
      return false
    end
  end
end
