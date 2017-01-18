class Banking < ApplicationRecord
  acts_as_paranoid

  attr_accessor :day
  attr_accessor :hour
  attr_accessor :venue

  belongs_to :venue, -> {with_deleted}
  belongs_to :payment_method, -> {with_deleted}

  validates :card_name, presence: true
  validates :card_number, presence: true
  validates :card_address, presence: true
  validates :banking_name, presence: true

  after_create :create_payment_method

  private
  def create_payment_method
    @payment_method = venue.payment_methods.new payment_type: Settings.payment_methods.banking
    if pending_time.nil?
      self.update_attributes payment_method: @payment_method, pending_time: Common.convert_hour(day.to_i, hour.to_i)
    else
      self.update_attributes payment_method: @payment_method
    end
  end
end
