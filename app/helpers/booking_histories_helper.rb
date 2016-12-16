module BookingHistoriesHelper

  def render_form_payment order, current_user
    if order.payment_detail_type != Settings.payment_methods.directly
      render partial: "booking_histories/user_payment_directly_form",
      locals: { order: order, current_user: current_user }
    end
  end

  def payment_directly_exist? order
    order.payment_detail.present?
  end
end
