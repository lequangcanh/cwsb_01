class PaymentMethod < ApplicationRecord
  acts_as_paranoid

  belongs_to :venue, -> {with_deleted}

  has_one :paypal
  has_one :banking, dependent: :destroy
  has_one :directly, dependent: :destroy

  validates :payment_type, presence: true
  validates :email, presence: true, length: {maximum: 255},
    format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}, if: :paypal?

  enum payment_type: {directly: 0, paypal: 1, banking: 2}

  scope :order_by_payment_type, -> {order :payment_type}
  scope :order_by_updated, -> {order updated_at: :desc}
end
