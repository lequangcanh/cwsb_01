module Admin::UsersHelper
  def get_alert_for_active user
    if user.active
      "#{user.name} " + t("admin.users.inactive_alert")
    else
      "#{user.name} " + t("admin.users.active_alert")
    end
  end

  def get_alert_for_block user
    if user.block
      "#{user.name} " + t("admin.users.unblock_alert")
    else
      "#{user.name} " + t("admin.users.block_alert")
    end
  end
end
