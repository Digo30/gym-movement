class Gym < ApplicationRecord
  has_many :appointments, dependent: :destroy
end
