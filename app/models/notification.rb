class Notification < ApplicationRecord
  include ActionView::Helpers::DateHelper

  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  belongs_to :order

  scope :unread, -> {where status: false}
  scope :newest, -> {order created_at: :desc}
  scope :by_receiver, -> receiver_id {where receiver_id: receiver_id}

  after_create_commit {NotificationBroadcastJob.perform_now(Notification.unread.count,self)}

  def load_message
    if load_venue
      banking = find_venue.banking.find_by verified: true
      directly = find_venue.directly.find_by verified: true
    end
    owner = User.find_by id: owner_id
    owner_name = if owner
      owner.name
    else
      User.name
    end

    case notifiable_type
    when Order.name
      "#{Order.name}: #{owner_name} #{I18n.t "notification.has"} #{message}
        #{I18n.t "store_bookings.booking"} #{time_ago_in_words(created_at)}
        #{I18n.t "notification.ago"} "
    when Booking.name
      "#{Booking.name}: #{I18n.t "notification.has"} #{message} #{time_ago_in_words(created_at)}
        #{I18n.t "notification.ago"} "
    when UserPaymentBanking.name
      "#{I18n.t "notification.payment"} #{owner_name} #{I18n.t "notification.has"} #{message}
        #{I18n.t "notification.banking"} #{time_ago_in_words(created_at)} #{I18n.t "notification.ago"}
        #{load_banking_message message, banking} "
    when UserPaymentDirectly.name
      "#{I18n.t "notification.payment"} #{owner_name} #{I18n.t "notification.has"} #{message}
        #{I18n.t "notification.directly"} #{time_ago_in_words(created_at)} #{I18n.t "notification.ago"}
        #{load_directly_message message, directly} "
    end
  end

  def load_banking_message message, banking
    if message
      owner_message_banking = if message == I18n.t("message.requested")
        owner_message_banking = nil
      elsif banking
        owner_message_banking = banking.message
      end
    end
  end

  def load_directly_message message, directly
    if message
      owner_message_directly = if message == I18n.t("message.requested")
        owner_message_directly = nil
      elsif directly
        owner_message_directly = directly.message
      end
    end
  end

  def load_venue
    if notifiable_type != Order.name
      notifiable.order.venue
    else
      notifiable.venue
    end
  end
end
