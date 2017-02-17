class User < ApplicationRecord
  include RecordFindingByTime
  after_save :send_mail_if_status_changed, if: :status_changed?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :async,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable,:omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  ratyrate_rater

  has_one :image, as: :imageable
  has_many :bookings
  has_many :reviews
  has_many :invoices, through: :bookings
  has_many :notifications, as: :receiver
  has_many :user_role_venues
  has_many :roles, through: :user_role_venues
  has_many :venues, through: :user_role_venues
  has_many :orders, through: :venues
  has_many :user_payment_bankings
  has_many :user_payment_directlies
  has_many :reports
  has_many :supports

  enum status: {active: 1, blocked: 2, reject: 3}

  validates :status, presence: true
  validates :name, presence: true

  accepts_nested_attributes_for :image, allow_destroy: true

  def self.from_omniauth auth
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = Devise.friendly_token[8,16]
      user.skip_confirmation!
    end
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def send_mail_if_status_changed
    UserMailer.change_user_status(self).deliver_later
  end

  def have_default_payment_method?
    if self.venues.any?
      venues.each do |venue|
        return true if venue.have_payment_method?
      end
    end
    false
  end

  def is_user? user
    self == user
  end
end
