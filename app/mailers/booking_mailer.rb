class BookingMailer < ApplicationMailer

  def change_status_booking state, email
    @state = state
    mail to: email, subject: t("bookings.email")
  end
end
