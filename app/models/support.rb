class Support < ApplicationRecord
  belongs_to :user

  validates :content, presence: true

  after_create :send_message

  scope :of_user, -> user_id do
    where user_id: user_id
  end

  private
  def send_message
    SupportBroadcastJob.perform_now self
  end
end
