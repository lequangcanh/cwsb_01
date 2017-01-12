class Activity < PublicActivity::Activity
  scope :order_desc, -> {order created_at: :desc}
end
