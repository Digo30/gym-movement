# Limpar dados antigos
Appointment.destroy_all
Profile.destroy_all
Gym.destroy_all
User.destroy_all

# Array de comodidades possíveis
amenities_list = [
  "Piscina", "Sauna", "Ar-condicionado", "Armarios", "Lanchonete",
  "Wi-fi", "Chuveiro", "Bicicletario", "Estacionamento"
]

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

# Criar academias
# Selecionar 3 comodidades aleatórias para cada academia
  amenities_list = ["Piscina", "Sauna", "Ar condicionado", "Armários", "Lanchonete", "Wi-fi", "Chuveiro", "Bicicletario", "Estacionamento"]

  gyms = 5.times.map do |i|
    Gym.create!(
      name: "Academia #{i}",
      address: "Rua #{i}, Cidade #{i}",
      latitude: -20.0 + i,
      longitude: -40.0 + i,
      phone: "555-1234#{i}",
      email: "contato#{i}@academia.com",
      rating: (4 + i % 2),
      info_shift: "Aberto 24/7",
      amenities: amenities_list.sample(3),  # Seleciona 3 comodidades aleatórias
      capacity: 100 + i * 10,
      photos: "https://example.com/academia#{i}.jpg"
    )
  end

# Criar compromissos
appointments = users.each_with_index.map do |user, i|
  Appointment.create!(
    user: user,
    gym: gyms[i % gyms.size],
    checkin_date: Date.today + i,
    checkin_hour: Time.now,
    checkout_date: Date.today + i,
    checkout_hour: Time.now + 2.hours,
    active: [true, false].sample
  )
end

puts "Dados seed inseridos com sucesso!"

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
