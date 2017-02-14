class Review < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :reviewable, polymorphic: true

  validates :content, presence: true
  validates :user, presence: true

  scope :created_desc, -> {order created_at: :desc}

  scope :load_more_desc, -> id {where "id < ?", id}

  scope :of_object, -> object {where reviewable: object}

  def is_end_of_desc_list_data_by_object? object
    Review.of_object(object).load_more_desc(self.id).empty?
  end
end
