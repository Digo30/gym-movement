class Gym < ApplicationRecord
  validates :images, presence: true, allow_blank: true
  has_many :appointments, dependent: :destroy
  has_one_attached :image
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
