class Report < ApplicationRecord
  belongs_to :user
  belongs_to :venue
  
  validates :content, presence: true

  scope :order_report, ->{order created_at: :desc}
end
