class UserMailer < ApplicationMailer
  def change_user_status user
    @user = user
    mail to: user.email, subject: t("users.mailer.status.subject")
  end
end
