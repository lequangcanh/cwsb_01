class City < ApplicationRecord
  belongs_to :country

  has_many :counties

  validates :name, presence: true
  validates :postal_code, presence: true
end
