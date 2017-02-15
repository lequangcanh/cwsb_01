class Booking < ApplicationRecord
  include GeneralHelper
  include PublicActivity::Model
  include RecordFindingByTime

  tracked owner: Proc.new{|controller, model| controller.current_user}

  attr_accessor :message

  acts_as_paranoid

  belongs_to :user
  belongs_to :space, -> {with_deleted}
  belongs_to :booking_type
  belongs_to :order

  has_one :invoice
  has_many :notifications, as: :notifiable
  has_many :notifications, as: :receiver

  enum state: {pending: 0, requested: 1, accepted: 2, rejected: 3}

  after_update_commit :send_notification

  validates :booking_from, presence: true
  validates :duration, presence: true, numericality: {greater_than: 0}
  validates :quantity, presence: true, numericality: {greater_than: 0}
  validates :user, presence: true

  delegate :name, to: :booking_type, prefix: true, allow_nil: true
  delegate :name, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :space, prefix: true, allow_nil: true

  before_destroy :order_referenced_with_booking

  scope :without_order, -> do
    where order_id: nil
  end

  scope :have_order, -> do
    where.not order_id: nil
  end

  scope :recent, -> {order(created_at: :desc)}

  scope :group_by_order, -> state do
    send(state).group_by{|booking| booking.order}
  end

  scope :load_resourse_to_reject, -> date do
    joins("LEFT JOIN orders ON bookings.order_id = orders.id")
      .where "date(bookings.booking_from) = date(?) AND
        (bookings.state = ? OR bookings.state = ? OR orders.status = ?)",
        date, Settings.state_pending, Settings.requested, Settings.status_pending
  end

  scope :of_space_ids, -> space_ids {where space_id: space_ids}

  def total_price
    select_price(space, booking_type_id) * quantity
  end

  def order_referenced_with_booking
    @order = Order.find_by id: order_id
    if @order
      @order.update_attributes deleted_at: Time.current() unless @order.bookings.any?
    end
  end

  private
  def send_notification
    owner_space_ids = self.space.venue.gets_owner
    owner_space_ids.each do |owner_space_id|
      case
      when rejected?
        if message.present?
          notifications.create message: self.message, receiver: self.user, owner_id: owner_space_id
        end
      when requested?
        notifications.create message: :requested, receiver_type: User.name, receiver_id: owner_space_id, owner_id: self.user.id
      when accepted?
        notifications.create message: :accepted, receiver: self.user, owner_id: owner_space_id
      end
    end
  end
end
