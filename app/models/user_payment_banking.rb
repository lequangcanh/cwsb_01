class UserPaymentBanking < ApplicationRecord
  attr_accessor :order

  has_many :orders, as: :payment_details
  has_many :notifications, as: :notifiable
  belongs_to :user

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
    owner = order.venue.user_role_venues.find_by type_role: UserRoleVenue.owner
    case
    when pending?
      notifications.create message: :requested, receiver_id: owner.id, owner_id: user.id
    end
  end

  def update_status_order
    order = Order.find_by payment_detail_id: id, payment_detail_type: UserPaymentBanking.name
    order.update_attributes status: Order.statuses[:paid]
    owner = order.venue.user_role_venues.find_by type_role: UserRoleVenue.owner
    case
    when rejected?
      notifications.create message: :rejected, receiver_id: user.id, owner_id: owner.id
    when accepted?
      notifications.create message: :accepted, receiver_id: user.id, owner_id: owner.id
    end
  end

  def check_status_without_accepted?
    !self.accepted?
  end
end
