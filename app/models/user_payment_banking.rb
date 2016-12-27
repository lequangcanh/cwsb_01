class UserPaymentBanking < ApplicationRecord

  attr_accessor :order

  has_many :orders, as: :payment_details

  enum status: {rejected: 0, pending: 1, accepted: 2}

  validates :card_name, presence: true
  validates :card_number, presence: true
  validates :card_address, presence: true
  validates :banking_name, presence: true
  validates :email, presence: true

  after_create :update_payment_method_of_order
  after_update :update_status_order
  before_update :check_status_without_accepted?

  def update_payment_method_of_order
    order.update_attributes payment_detail_id: id,
      payment_detail_type: UserPaymentBanking.name
  end

  def update_status_order
    order = Order.find_by payment_detail_id: id, payment_detail_type: UserPaymentBanking.name
    order.update_attributes status: Order.statuses[:paid]
  end

  def check_status_without_accepted?
    !self.accepted?
  end
end
