class SupportBroadcastJob < ApplicationJob
  queue_as :default

  def perform message
    admin_unread_count = message.user.supports.admin_unread.count
    user_unread_count = message.user.supports.user_unread.count
    ActionCable.server.broadcast "user_#{message.user.id}_channel",
      message: render_message(message), admin_unread_count: admin_unread_count,
      user_unread_count: user_unread_count
  end

  private
  def render_message message
    ApplicationController.render partial: "supports/support",
      locals: {support: message}
  end
end
