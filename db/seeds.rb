require 'faker'

# Limpar dados antigos
Appointment.destroy_all
Profile.destroy_all
Gym.destroy_all
User.destroy_all

puts "Dados antigos limpados"

# Criar usuários
users = 5.times.map do |i|
  User.create!(
    email: "user#{i}@example.com",
    password: "123456",
    password_confirmation: "123456",
    first_name: "FirstName#{i}",
    last_name: "LastName#{i}",
    birthday: Date.new(1990 + i, 1, 1),
    gender: ["Male", "Female"].sample,
    phone: "555-000#{i}",
    user_image: "https://example.com/user#{i}.jpg"
  )
end

# Criar perfis
profiles = users.map.with_index do |user, i|
  Profile.create!(
    user: user,
    weight: (60 + i * 2).to_f,
    height: (170 + i * 2).to_f,
    photo: "https://example.com/photo#{i}.jpg"
  )
end

# Método para gerar coordenadas dentro da região central de São Paulo
def generate_coordinates
  latitude = rand(-23.5500..-23.5400)  # Ajustando para um intervalo mais estreito
  longitude = rand(-46.6350..-46.6200)  # Ajustando para um intervalo mais estreito
  [latitude, longitude]
end


# Método para gerar um endereço a partir da latitude e longitude (simulação)
def generate_address(latitude, longitude)
  "Rua #{rand(1..100)}, Bairro #{['Centro', 'Vila', 'Jardim', 'Parque'].sample}, Cidade São Paulo, #{latitude.round(4)}, #{longitude.round(4)}"
end

# Array de comodidades possíveis
amenities_list = [
  "Piscina", "Sauna", "Ar-condicionado", "Armarios", "Lanchonete",
  "Wi-fi", "Chuveiro", "Bicicletario", "Estacionamento"
]

# Criando 5 academias com comodidades, coordenadas e endereço
gyms = 5.times.map do |i|
  latitude, longitude = generate_coordinates
  address = generate_address(latitude, longitude)

  Gym.create!(
    name: "Academia #{i + 1}",
    address: address,  # Agora com o endereço gerado
    latitude: latitude,
    longitude: longitude,
    phone: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.email(name: "academia#{i + 1}"),
    rating: rand(3..5), # Geração de notas entre 3 e 5
    info_shift: "Aberto 24/7",
    amenities: amenities_list.sample(3), # Seleciona 3 amenidades aleatórias
    capacity: 100 + i * 10, # Capacidade incremental
    photos: "https://example.com/academia#{i + 1}.jpg"
  )
end

# Criar compromissos
appointments = users.each_with_index.map do |user, i|
  Appointment.create!(
    user: user,
    gym: gyms[i % gyms.size], # Garantir que o compromisso seja para uma das academias
    checkin_date: Date.today + i,
    checkin_hour: Time.now,
    checkout_date: Date.today + i,
    checkout_hour: Time.now + 2.hours,
    active: [true, false].sample
  )
end

# Criar um compromisso específico
user = User.find_by(id: 6)
gym = Gym.find_by(id: 7)

if user && gym
  Appointment.create!(
    user: user,
    gym: gym,
    checkin_date: Date.today,
    checkin_hour: Time.current,
    checkout_date: Date.today,
    checkout_hour: Time.current + 2.hours,
    active: [true, false].sample
  )
else
  puts "Usuário com ID 6 ou Academia com ID 7 não encontrado."
end

puts "Dados seed inseridos com sucesso!"
