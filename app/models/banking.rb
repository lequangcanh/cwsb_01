class Banking < ApplicationRecord
  belongs_to :venue
  belongs_to :payment_method

  validates :card_name, presence: true
  validates :card_number, presence: true
  validates :card_address, presence: true
  validates :banking_name, presence: true
end
