module ApplicationHelper
  def full_title page_title = ""
    base_title = t "layout.base_title"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def count_notification_read
    if user_signed_in?
      current_noti_unread = @count_notification_unread
    end
  end

  def status_unread notification
    unless notification.status?
      t "notification.unread"
    end
  end
end
