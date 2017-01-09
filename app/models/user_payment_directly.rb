class UserPaymentDirectly < ApplicationRecord

  attr_accessor :order_payment

  has_one :order, as: :payment_detail
  has_many :notifications, as: :notifiable
  belongs_to :user

  enum status: { rejected: 0, pending: 1, accepted: 2 }

  validates :name, presence: true
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :phone, presence: true

  after_create :update_payment_method_of_order
  after_update :update_status_order

  def update_payment_method_of_order
    order_payment.update_attributes payment_detail_id: id,
      payment_detail_type: UserPaymentDirectly.name
    owners = order_payment.venue.gets_owner
    owners.each do |owner|
      case
      when pending?
        notifications.create message: :requested, receiver_id: owner.user.id, owner_id: user.id
      end
    end
  end

  def update_status_order
    order_payment = Order.find_by payment_detail_id: id, payment_detail_type: UserPaymentDirectly.name
    order_payment.update_attributes status: Order.statuses[:paid]
    owners = order_payment.venue.gets_owner
    owners.each do |owner|
      case
      when rejected?
        notifications.create message: :rejected, receiver_id: user.id, owner_id: owner.user.id
      when accepted?
        notifications.create message: :accepted, receiver_id: user.id, owner_id: owner.user.id
      end
    end
  end
end
