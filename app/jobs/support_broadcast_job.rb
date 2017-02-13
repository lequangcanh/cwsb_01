class SupportBroadcastJob < ApplicationJob
  queue_as :default

  def perform message
    ActionCable.server.broadcast "user_#{message.user.id}_channel",
      message: render_message(message)
  end

  private
  def render_message message
    ApplicationController.render partial: "supports/support",
      locals: {support: message}
  end
end
