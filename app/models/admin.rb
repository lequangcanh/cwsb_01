class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :validatable, password_length: 8..16

  belongs_to :role
end
