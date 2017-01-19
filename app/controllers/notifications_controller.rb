class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = @notifications.page(params[:page]).per Settings.notification.index
  end

  def update
    @notification = Notification.find_by id: params[:id]
    @notification.update_attributes status: true
  end
end
