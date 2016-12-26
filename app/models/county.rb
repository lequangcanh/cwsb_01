class County < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :city

  has_many :addresses

  validates :name, presence: true
end
