module OrderHistoriesHelper

  def display_status order
    case
    when order.requested?
      Settings.span_warning
    when order.pending?
      Settings.span_info
    when order.paid?
      Settings.span_success
    else
      Settings.span_danger
    end
  end

  def render_payment_detail_type order
    case order.payment_detail_type
    when Settings.payment_methods_filter[:directly]
      image_tag("payment_methods/directly_logo.png", class: "image_index")
    when Settings.payment_methods_filter[:paypal]
      image_tag("payment_methods/paypal_logo.png", class: "image_index")
    when Settings.payment_methods_filter[:banking]
      image_tag("payment_methods/banking_logo.png", class: "image_index")
    else
      t ".undefined"
    end
  end

  def render_customer_detail order
    if order.payment_detail_type == Settings.payment_methods_filter[:directly]
      render "customer_detail", order: order
    end
  end
end
