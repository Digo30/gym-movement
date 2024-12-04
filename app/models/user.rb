class User < ApplicationRecord
  has_many :appointments, dependent: :destroy
  has_many :profiles, dependent: :destroy
  has_one_attached :image
  has_one_attached :profile_picture
  has_one_attached :photo

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
