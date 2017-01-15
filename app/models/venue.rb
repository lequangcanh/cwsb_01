class Venue < ApplicationRecord
  include RecordFindingByTime
  include PublicActivity::Model

  tracked owner: Proc.new{|controller, model| controller.current_user}

  acts_as_paranoid

  has_one :address, dependent: :destroy, inverse_of: :venue
  has_many :images, as: :imageable
  has_many :user_role_venues, dependent: :destroy
  has_many :users, through: :user_role_venues
  has_many :amenities, through: :venue_amenities
  has_many :venue_amenities, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :spaces, dependent: :destroy
  has_many :working_times, dependent: :destroy
  has_many :payment_methods, dependent: :destroy
  has_many :banking, through: :payment_methods
  has_many :directly, through: :payment_methods
  has_many :orders
  has_one :user_payment_directly

  attr_accessor :user

  after_create :create_user_role_venue
  after_create :build_working_time
  after_create :add_default_amenity

  validates :description, presence: true
  validates :name, presence: true

  delegate :details, :city, :street_address, :postal_code, :unit,
    to: :address, prefix: true, allow_nil: true

  accepts_nested_attributes_for :address, allow_destroy: true
  accepts_nested_attributes_for :images, allow_destroy: true
  accepts_nested_attributes_for :working_times, allow_destroy: true

  scope :order_created, ->{order created_at: :desc}

  scope :count_spaces, -> do
    joins(:spaces)
      .select("count(*) as quantities, venues.*")
      .group :venue_id
  end

  def create_user_role_venue
    user_role_venues.create user: user, type_role: Settings.owner_role
  end

  def build_working_time
    WorkingTime.day_in_weeks.each do |day, value|
      self.working_times.create day_in_week: day,
        working_to: Settings.working_to, working_from: Settings.working_from,
        status: Settings.status_open
    end
  end

  def add_default_amenity
    default_amenities = Amenity.default
    default_amenities.each do |default_amenity|
      venue_amenities.create venue_id: id, amenity_id: default_amenity.id
    end
  end

  def gets_owner
    user_role_venues.where type_role: UserRoleVenue.type_roles[:owner]
  end

  def check_condition?
    orders.where(status: [:requested, :pending]).each do |order|
      order.bookings.where(state: [:requested, :pending]).each do |booking|
        return true unless booking.accepted?
      end
    end
    false
  end
end
