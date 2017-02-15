class ReadsController < ApplicationController
  def update
    Notification.by_receiver(current_user).unread.update_all status: true
    respond_to do |format|
      format.js
    end
  end
end
