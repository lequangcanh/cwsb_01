class Country < ApplicationRecord
  acts_as_paranoid
  
  has_many :cities

  validates :name, presence: true
  validates :country_code, presence: true
end
