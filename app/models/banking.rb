class Banking < ApplicationRecord
  attr_accessor :day
  attr_accessor :hour

  belongs_to :venue
  belongs_to :payment_method

  validates :card_name, presence: true
  validates :card_number, presence: true
  validates :card_address, presence: true
  validates :banking_name, presence: true

  after_create :calculate_pending_time

  private
  def calculate_pending_time
    self.update_attributes pending_time: (day.to_i * 24 + hour.to_i)
  end
end
