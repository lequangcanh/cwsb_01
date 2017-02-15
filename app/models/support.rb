class Support < ApplicationRecord
  belongs_to :user

  validates :content, presence: true

  after_create :send_message

  scope :of_user, -> user_id do
    where user_id: user_id
  end
  scope :admin_unread, -> {where is_read: false, from_admin: false}
  scope :user_unread, -> {where is_read: false, from_admin: true}
  scope :created_desc, -> {order created_at: :desc}
  scope :latest_user_id, -> {self.created_desc.pluck(:user_id).uniq}

  private
  def send_message
    SupportBroadcastJob.perform_now self
  end
end
