class PaymentMailer < ApplicationMailer

  def change_status_payment_directly status, email
    @status = status
    mail to: email, subject: t("payments.directly.email")
  end

  def change_status_payment_banking status, email
    @status = status
    mail to: email, subject: t("payments.banking.email")
  end
end
