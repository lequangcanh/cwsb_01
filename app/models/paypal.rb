class Paypal < ApplicationRecord
  has_one :order, as: :payment_method
  belongs_to :payment_method

  attr_accessor :order

  after_create :update_payment_paypal_of_order

  def paypal_url(return_path)
    values = {
      business: self.payment_method.email,
      cmd: "_cart",
      upload: 1,
      return: "#{Settings.ngrok_host}#{return_path}",
      invoice: id,
      notify_url: "#{Settings.ngrok_host}/hook"
    }
    order.bookings.accepted.each_with_index do |booking, index|
      values.merge!({
        "amount_#{index+1}":
          booking.select_price(booking.space, booking.booking_type_id) * booking.duration,
        "item_name_#{index+1}": booking.space_name,
        "item_number_#{index+1}": booking.id,
        "quantity_#{index+1}": booking.quantity,
      })
    end
    "#{Settings.paypal_host}/cgi-bin/webscr?" + values.to_query
  end

  def update_payment_paypal_of_order
    order.update_attributes payment_detail_id: id,
      payment_detail_type: Paypal.name
  end
end
