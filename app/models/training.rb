# app/models/training.rb
class Training < ApplicationRecord
  belongs_to :user

  validates :content, presence: true
  validates :user, presence: true

  # Opcional: validação para evitar duplicatas no mesmo dia para o mesmo usuário
  validates :content, uniqueness: { scope: [:user_id, :created_at],
    conditions: -> { where("created_at >= ?", Time.current.beginning_of_day) } }
end
