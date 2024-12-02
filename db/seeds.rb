# Limpar dados antigos
User.destroy_all
Profile.destroy_all
Gym.destroy_all
Appointment.destroy_all

# Criar usuários
users = 5.times.map do |i|
  User.create!(
    email: "user#{i}@example.com",
    password: "password#{i}",    # Adicionar senha válida
    password_confirmation: "password#{i}" # Confirmar a senha
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
gyms = 5.times.map do |i|
  Gym.create!(
    name: "Gym #{i}",
    address: "Street #{i}, City #{i}",
    latitude: -20.0 + i,
    longitude: -40.0 + i,
    phone: "555-1234#{i}",
    email: "contact#{i}@gym.com",
    rating: (4 + i % 2),
    info_shift: "Open 24/7",
    amenities: "Pool, Sauna, Free weights",
    capacity: 100 + i * 10,
    photos: "https://example.com/gym#{i}.jpg"
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
