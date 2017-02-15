class AdminNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "admin_notification_channel_#{current_admin.id}"
  end

  def unsubscribed
  end
end
