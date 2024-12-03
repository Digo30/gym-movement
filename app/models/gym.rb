class Gym < ApplicationRecord
  validates :images, presence: true, allow_blank: true
  has_many :appointments, dependent: :destroy
  has_one_attached :image
end
