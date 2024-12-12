require 'faker'
require 'open-uri'
require 'httparty'
require 'json'

# Limpar dados antigos
Appointment.destroy_all
Profile.destroy_all
Gym.destroy_all
User.destroy_all

puts "Dados antigos limpados"

def fetch_random_user_data(gender, count)
  response = HTTParty.get("https://randomuser.me/api/?gender=#{gender}&results=#{count}")
  JSON.parse(response.body)['results']
end

# Criação dos usuários masculinos
male_users_data = fetch_random_user_data('male', 9)
male_users_data.each_with_index do |user_data, i|
  puts "Creating male user #{i + 1} with email: #{user_data['email']}"
  user = User.new(
    email: user_data['email'],
    password: "123456",
    password_confirmation: "123456",
    first_name: user_data['name']['first'],
    last_name: user_data['name']['last'],
    birthday: Date.parse(user_data['dob']['date']),
    gender: "Male",
    phone: user_data['phone']
  )

  # Anexar a foto de perfil
  begin
    file = URI.open(user_data['picture']['large'])
    user.profile_picture.attach(io: file, filename: "profile_picture_male_#{i}.jpg", content_type: 'image/jpeg')
  rescue OpenURI::HTTPError => e
    puts "Error opening URL: #{user_data['picture']['large']}"
    puts e.message
    next
  end

  # Salvar o usuário
  user.save!
end

# Criação dos usuários femininos
female_users_data = fetch_random_user_data('female', 9)
female_users_data.each_with_index do |user_data, i|
  puts "Creating female user #{i + 1} with email: #{user_data['email']}"
  user = User.new(
    email: user_data['email'],
    password: "123456",
    password_confirmation: "123456",
    first_name: user_data['name']['first'],
    last_name: user_data['name']['last'],
    birthday: Date.parse(user_data['dob']['date']),
    gender: "Female",
    phone: user_data['phone']
  )

  # Anexar a foto de perfil
  begin
    file = URI.open(user_data['picture']['large'])
    user.profile_picture.attach(io: file, filename: "profile_picture_female_#{i}.jpg", content_type: 'image/jpeg')
  rescue OpenURI::HTTPError => e
    puts "Error opening URL: #{user_data['picture']['large']}"
    puts e.message
    next
  end

  # Salvar o usuário
  user.save!
end

def generate_coordinates
  latitude = rand(-23.5500..-23.5400)  # Ajustando para um intervalo mais estreito
  longitude = rand(-46.6350..-46.6200)  # Ajustando para um intervalo mais estreito
  [latitude, longitude]
end

# Array de comodidades possíveis
amenities_list = [
  "Piscina", "Sauna", "Ar-condicionado", "Armarios", "Lanchonete",
  "Wi-fi", "Chuveiro", "Bicicletario", "Estacionamento"
]

json_data = File.read('db/data/academias.json')
academias = JSON.parse(json_data)

puts "Usuários criados com sucesso!"

# Criando academias com comodidades, coordenadas, endereço e imagem
gyms = 15.times.map do |i|
  latitude, longitude = generate_coordinates
  address = academias[i]["endereco"]

  gym = Gym.new(
    name: academias[i]["nome"],
    address: address,  # Agora com o endereço gerado
    latitude: latitude,
    longitude: longitude,
    phone: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.email(name: academias[i]["nome"].downcase.tr(" ", "_")),
    rating: rand(3..5), # Geração de notas entre 3 e 5
    info_shift: "Aberto 24/7",
    amenities: amenities_list.sample(3),
    capacity: 100 + i * 10 # Capacidade incremental
  )

  begin
    file = URI.open(academias[i]["imagem_url"])
    puts "Anexando imagem principal: #{academias[i]["imagem_url"]}"
    gym.gym_image.attach(io: file, filename: "gym_image#{i}.jpg", content_type: 'image/jpeg')

    # Anexar imagens à academia
    academias[i]["imagens_da_estrutura"].each_with_index do |image_url, index|
      file = URI.open(image_url)
      puts "Anexando imagem adicional: #{image_url}"
      gym.images.attach(io: file, filename: "gym_image#{i}_#{index}.jpg", content_type: 'image/jpeg')
    end
  rescue OpenURI::HTTPError => e
    puts "Error opening URL: #{academias[i]["imagem_url"]}"
    puts e.message
    next
  end

  if gym.save
    puts "Academia #{gym.name} salva com sucesso!"
    gym # Retorna o objeto Gym salvo
  else
    puts "Erro ao salvar academia: #{gym.errors.full_messages.join(", ")}"
    nil # Retorna nil em caso de falha
  end
end.compact # Remove valores nil do array

puts "Academias criadas: #{gyms.compact.map(&:name)}"

# Criar 50 compromissos (check-ins)
2000.times do |i|
  user = User.order("RANDOM()").first  # Seleciona um usuário aleatório para o check-in
  gym = Gym.order("RANDOM()").first    # Seleciona uma academia aleatória para o check-in

  Appointment.create!(
    user: user,
    gym: gym,
    checkin_date: Date.today,
    checkin_hour: Time.now,
    checkout_date: Date.today,
    checkout_hour: Time.now,
    active: [true, false].sample
  )
end

puts "50 check-ins criados com sucesso!"
