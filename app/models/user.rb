class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :async,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable
  devise :database_authenticatable, :validatable, password_length: 8..16

  has_one :image
  has_many :bookings
  has_many :reviews
  has_many :invoices, through: :bookings
  has_many :notifications
  has_many :user_role_venues
  has_many :roles, through: :user_role_venues
  has_many :venues, through: :user_role_venues
  has_many :orders, through: :venues

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
