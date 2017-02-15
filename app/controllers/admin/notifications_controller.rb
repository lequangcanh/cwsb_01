class Admin::NotificationsController < Admin::BaseController

  def index
    @notifications = @notifications_admin.page(params[:page]).per Settings.notification.index
  end
end
