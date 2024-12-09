class FoodIntake < ApplicationRecord
  belongs_to :user

    # Adicione validação, se necessário
    validates :product_name, presence: true
    validates :calories, presence: true
    validates :date, presence: true
    validates :product_image, presence: true # Se a imagem for obrigatória
end
