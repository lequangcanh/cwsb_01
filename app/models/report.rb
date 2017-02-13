class Report < ApplicationRecord
  belongs_to :user
  belongs_to :venue
  has_many :notifications, as: :notifiable

  after_create :send_notification
  validates :content, presence: true

  scope :order_report, ->{order created_at: :desc}

  def send_notification
    admins = Admin.all
    admins.each do |admin|
      notifications.create message: :reported, receiver: admin, owner_id: user_id
    end
  end
end
