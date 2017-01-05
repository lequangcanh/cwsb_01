class Directly < ApplicationRecord
  belongs_to :payment_method
  belongs_to :venue

  validates :pending_time, numericality: {greater_than_or_equal_to: 0}, allow_nil: true

  after_create :create_payment_method

  attr_accessor :venue
  attr_accessor :day
  attr_accessor :hour

  private
  def create_payment_method
    @payment_method = venue.payment_methods.new payment_type: Settings.payment_methods.directly
    self.update_attributes payment_method: @payment_method, pending_time: Common.convert_hour(day.to_i, hour.to_i)
  end
end
