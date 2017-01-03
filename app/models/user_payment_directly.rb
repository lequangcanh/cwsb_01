class UserPaymentDirectly < ApplicationRecord

  attr_accessor :order

  belongs_to :user

  has_many :orders, as: :payment_details
  has_many :notifications, as: :notifiable

  enum status: { rejected: 0, pending: 1, accepted: 2 }

  validates :name, presence: true
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :phone, presence: true

  after_create :update_payment_method_of_order
  after_update :update_status_order

  def update_payment_method_of_order
    order.update_attributes payment_detail_id: id,
      payment_detail_type: UserPaymentDirectly.name
    owner = order.venue.user_role_venues.find_by type_role: UserRoleVenue.owner
    case
    when pending?
      notifications.create message: :requested, receiver_id: owner.id, owner_id: user.id
    end
  end

  def update_status_order
    order = Order.find_by payment_detail_id: id, payment_detail_type: UserPaymentDirectly
    order.update_attributes status: Order.statuses[:paid]
    owner = order.venue.user_role_venues.find_by type_role: UserRoleVenue.owner
    case
    when rejected?
      notifications.create message: :rejected, receiver_id: user.id, owner_id: owner.id
    when accepted?
      notifications.create message: :accepted, receiver_id: user.id, owner_id: owner.id
    end
  end
end
