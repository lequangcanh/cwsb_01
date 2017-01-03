class Directly < ApplicationRecord
  belongs_to :payment_method
  belongs_to :venue

  validates :pending_time, numericality: {greater_than: 0}

  after_create :create_payment_method

  attr_accessor :venue

  private
  def create_payment_method
    @payment_method = venue.payment_methods.new payment_type: Settings.payment_methods.directly
    self.update_attributes payment_method: @payment_method
  end
end
