class Gym < ApplicationRecord
  has_many :appointments, dependent: :destroy
  has_one_attached :image
end
