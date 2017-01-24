class Review < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :venue
  belongs_to :space

  validates :content, presence: true
  validates :user, presence: true
  validates :space, presence: true

  scope :created_desc, -> {order created_at: :desc}

  scope :load_more_desc, -> id {where "id < ?", id}

  def is_end_of_desc_list_data?
    Review.load_more_desc(self.id).empty?
  end
end
