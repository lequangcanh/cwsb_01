class Admin::ReadsController < Admin::BaseController
  def update
    Notification.by_receiver(current_admin).unread.update_all status: true
    respond_to do |format|
      format.js
    end
  end
end
