class Order < ApplicationRecord
  after_create :update_booking

  attr_accessor :booking_ids

  belongs_to :coupon
  belongs_to :venue
  belongs_to :payment_detail, polymorphic: true

  has_one :paypal

  has_many :bookings, dependent: :destroy

  enum status: {requested: 0, pending: 1, paid: 2, closed: 3}

  scope :have_order_payment_directly, -> do
    where payment_detail_type: UserPaymentDirectly.name
  end
  scope :recent, ->{order :created_at}

  scope :filter_by_payment_detail, ->payment_detail_type do
    where payment_detail_type: payment_detail_type if payment_detail_type.present?
  end
  scope :filter_by_status, ->status do
    where status: status if status.present?
  end

  after_update :delete_paypal_after_change_method

  def delete_paypal_after_change_method
    if self.payment_detail_type != Paypal
      self.paypal.destroy if self.paypal
    end
  end

  def update_booking
    @booking_ids = booking_ids.split(" ")
    @booking_ids.each do |booking_id|
      booking = Booking.find_by id: booking_id
      booking.update_attributes order_id: self.id, state: "requested"
    end
  end

  def load_email_paypal
    self.venue.payment_methods.paypal.find_by is_chosen: true
  end
end
