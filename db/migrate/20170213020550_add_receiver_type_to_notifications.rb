class AddReceiverTypeToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :receiver_type, :string
  end
end
