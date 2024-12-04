class User < ApplicationRecord
  has_many :appointments, dependent: :destroy
  has_many :profiles, dependent: :destroy
  has_one_attached :image
  has_one_attached :profile_picture
  has_one_attached :photo

  validates :first_name, :last_name, presence: true, length: { minimum: 2 }
  validates :birthday, presence: true


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  # Método para calcular a idade
  def age
    return unless birthday

    today = Date.today
    age = today.year - birthday.year
    # Ajusta se o aniversário ainda não ocorreu no ano atual
    age -= 1 if today.month < birthday.month || (today.month == birthday.month && today.day < birthday.day)
    age
  end

end
