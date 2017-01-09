class UserMailer < ApplicationMailer
  def block_user user
    @user = user
    mail to: user.email, subject: t("users.mailer.block.block_user")
  end

  def unblock_user user
    @user = user
    mail to: user.email, subject: t("users.mailer.unblock.unblock_user")
  end
end
