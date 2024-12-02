class User < ApplicationRecord
  has_many :appointments, dependent: :destroy
  has_many :profiles, dependent: :destroy


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
