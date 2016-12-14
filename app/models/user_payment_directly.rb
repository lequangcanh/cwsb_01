class UserPaymentDirectly < ApplicationRecord

  attr_accessor :order

  has_many :orders, as: :payment_details

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
  end

  def update_status_order
    order = Order.find_by payment_detail_id: id
    order.update_attributes status: Order.statuses[:paid]
  end
end
