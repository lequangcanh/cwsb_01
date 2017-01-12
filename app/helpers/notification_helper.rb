module NotificationHelper
  def load_link_notification status_message, notifiable_type
    case status_message
    when Settings.notification.requested
      find_notifiable_type notifiable_type
    when Settings.notification.accepted
      booking_histories_path
    else
      booking_histories_path
    end
  end

  def find_notifiable_type notifiable_type
    case notifiable_type
    when Order.name || Booking.name
      store_bookings_path
    when UserPaymentDirectly.name
      confirm_payment_directlies_path
    when UserPaymentBanking.name
      confirm_payment_bankings_path
    else
      root_path
    end
  end
end
