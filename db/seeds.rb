require 'faker'
require 'open-uri'

# Limpar dados antigos
Appointment.destroy_all
Profile.destroy_all
Gym.destroy_all
User.destroy_all

puts "Dados antigos limpados"

# URLs das imagens de perfil para usuários masculinos
male_profile_pictures = [
  "https://plus.unsplash.com/premium_photo-1678703870962-166fe3f1d274?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyZmlsJTIwbWFzY3VsaW5vfGVufDB8fDB8fHww",
  "https://neopix.com.br/wp-content/uploads//2021/04/fotografo-empresarial.jpg",
  "https://media.istockphoto.com/id/931693612/pt/foto/the-happy-business-afro-american-man-standing-and-smiling-against-blue-background-profile-view.jpg?s=612x612&w=0&k=20&c=YMtk_NheISqjEU7Z-mEsJc6I9aatNq406Jw619AuYrk=",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhAkpaOoSBkLRoq5iOQD9idXGMm-6dZg2BMw&s",
  "https://assets-br.wemystic.com.br/20191113010228/homem-capri-850x640.jpg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkxh01ys261iYB6LjBB2n66VcdBJZkRDi0RA&s",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwqmwKzMB5wLAcmnMrqslmxMme5z1lfKQC2g&s",
  "https://i.pinimg.com/236x/84/ff/5d/84ff5d4969b1b130975ee331269614c6.jpg",
  "https://i.pinimg.com/736x/31/6c/37/316c371de23a36343b999508c71270bf.jpg"
]

# URLs das imagens de perfil para usuários femininos
female_profile_pictures = [
  "https://i.pinimg.com/736x/4e/7b/75/4e7b7540dd1b95e727692dc32f59eeda.jpg",
  "https://media.istockphoto.com/id/638756792/pt/foto/beautiful-woman-posing-against-dark-background.jpg?s=612x612&w=0&k=20&c=nahL_uo1eM1c5-rECuRU-L0MExyy9p1FFWEqTpaazYg=",
  "https://images.pexels.com/photos/27304892/pexels-photo-27304892/free-photo-of-por-do-sol-moda-tendencia-mulher.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  "https://media.istockphoto.com/id/466807030/pt/foto/perfil-de-grande-mulher-de-neg%C3%B3cios-olhando-para-a-frente.jpg?s=612x612&w=0&k=20&c=4tVnfATNnP8S6UBl9PXb-LWFqx6KJ6bBnscltx2MFFU=",
  "https://i.pinimg.com/236x/8b/d2/ce/8bd2ce6ef5816dc26ae9e745e650d65f.jpg",
  "https://i.pinimg.com/originals/72/1f/15/721f157c1890a4bf127cc5dd15139555.jpg",
  "https://i.pinimg.com/736x/92/02/7d/92027d36e1237b0499422ccc46870481.jpg",
  "https://i.pinimg.com/736x/db/b1/31/dbb131fd77289a86e08921d23453869e.jpg",
  "https://i.pinimg.com/736x/c8/51/c5/c851c53651f9e9e4e793c3ee9192e215.jpg"
]

gym_images = [
  "https://marketplace.canva.com/EAFmkvts9ug/1/0/1600w/canva-logo-minimalista-academia-de-muscula%C3%A7%C3%A3o-amarelo-e-preto-WblQvfqAn7I.jpg",
  "https://apsd.com.br/wp-content/uploads/2021/11/12853-logo-academia-strong.webp",
  "https://www.zarla.com/images/zarla-vivafit-1x1-2400x2400-20210609-ryy6c6qmf4g3pjkbdpxj.png?crop=1:1,smart&width=250&dpr=2",
  "https://images-platform.99static.com/tFYxOlI4wM-okd_xZYBrcuU5ojE=/500x500/top/smart/99designs-contests-attachments/50/50164/attachment_50164580",
  "https://static.vecteezy.com/ti/vetor-gratis/t2/17504043-emblema-de-musculacao-e-modelo-de-de-design-de-logotipo-de-academia-vetor.jpg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3Fq--QaadgOR5cm0NTW-6gzPd2sfFENoQZQ&s",
  "https://pbs.twimg.com/profile_images/937704518069911552/1STiSfEm_400x400.jpg",
  "https://jockeyplaza.com.br/wp-content/uploads/2022/01/BLUEFIT.jpg"
]

additional_gym_images = [
  "https://scproduction.s3.sa-east-1.amazonaws.com/wysiwyg_uploads/cms/images/2018/10/01/19/07-h9ytse3i.JPG",
  "https://invexo.com.br/blog/wp-content/uploads/2022/12/smartfit-academias-na-barra-da-tijuca-rio-de-janeiro-1024x576.jpg.webp",
  "https://holdfit.com.br/wp-content/uploads/2022/05/musculacao-holdfit.jpg",
  "https://totalpass.com/wp-content/uploads/2022/09/como-montar-uma-academia-equipamentos.jpg",
  "https://www.26fit.com.br/fotos/produtos/gd_05d362.jpg",
  "https://www.movement.com.br//wp-content/uploads/2023/02/academia-fire-sport-2-min.jpg",
  "https://cronos-media.sesisenaisp.org.br/api/media/1-0/files?img=img_43_230110_f30ce3ce-10dd-489c-99e5-4bcd464d7677_o.jpeg&tipo=p",
  "https://tecnofit-site.s3.sa-east-1.amazonaws.com/media/files/2023/10/20160631/layout-para-academia-scaled.jpg",
  "https://www.movement.com.br//wp-content/uploads/2023/02/academia-Panobianco-Natal-6-min.jpg",
  "https://cdn.prod.website-files.com/63c83bcc0ba2e13003877238/6571e8d66ae5ac7c455758c2_Decorac%CC%A7a%CC%83o%20para%20Academias%20Como%20Melhorar%20sua%20Unidade.jpg",
  "https://vedovatipisos.com.br/wp-content/uploads/2018/09/Como-montar-uma-academia.jpg",
  "https://jeonline.com.br/images/noticias/24013/24013225144.jpg",
  "https://lh6.googleusercontent.com/proxy/vBS0I-wkwDFIKZ1cxlo2MbaeaC0WCfm9dYl4686flp3Wgp9KTTe_X-flk6vOEdQAQC08LE4CfDd1_fQUgJ4NXUOrB8JUGVkbJuvsmo10pUJqkYj09UY8A4Bstw",
  "https://www.movement.com.br//wp-content/uploads/2023/02/Academia-Live-Premium-min.jpg",
  "https://yata-apix-e98ae875-c6ca-42f3-8cb7-6f71eddc2559.s3-object.locaweb.com.br/ee507f472fdc4c298d801b2b51c6136e.png",
  "https://s2-gq.glbimg.com/4g1J7vWpaZwmy7G1kHjiiORDJGk=/0x0:1170x779/888x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_71a8fe14ac6d40bd993eb59f7203fe6f/internal_photos/bs/2024/B/A/WE4duCTBeh8VnOMudSwQ/bodytech2.jpg"
]


# Criação dos usuários masculinos
(6..14).each do |i|
  user = User.new(
    email: "user#{i}@example.com",
    password: "123456",
    password_confirmation: "123456",
    first_name: "FirstName#{i}",
    last_name: "LastName#{i}",
    birthday: Date.new(1990 + i, 1, 1),
    gender: "Male",
    phone: "555-000#{i}"
  )

  # Anexar a foto de perfil
  file = URI.open(male_profile_pictures[i - 6])
  user.profile_picture.attach(io: file, filename: "profile_picture#{i}.jpg", content_type: 'image/jpeg')

  # Salvar o usuário
  user.save!
end

# Criação dos usuários femininos
(15..23).each do |i|
  user = User.new(
    email: "user#{i}@example.com",
    password: "123456",
    password_confirmation: "123456",
    first_name: "FirstName#{i}",
    last_name: "LastName#{i}",
    birthday: Date.new(1990 + i, 1, 1),
    gender: "Female",
    phone: "555-000#{i}"
  )

  # Anexar a foto de perfil
  file = URI.open(female_profile_pictures[i - 15])
  user.profile_picture.attach(io: file, filename: "profile_picture#{i}.jpg", content_type: 'image/jpeg')

  # Salvar o usuário
  user.save!
end


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


puts "Usuários criados com sucesso!"
gym_names = [
  "Hanover Gym",
  "Academia Strong",
  "Vivafit",
  "Academia Pragmática",
  "Academia Vetor",
  "Pratique Fitness",
  "Smart Fit",
  "Bluefit"
]

# Criando academias com comodidades, coordenadas, endereço e imagem
gyms = 8.times.map do |i|
  latitude, longitude = generate_coordinates
  address = generate_address(latitude, longitude)

  gym = Gym.new(
    name: gym_names[i],
    address: address,  # Agora com o endereço gerado
    latitude: latitude,
    longitude: longitude,
    phone: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.email(name: gym_names[i].downcase.tr(" ", "_")),
    rating: rand(3..5), # Geração de notas entre 3 e 5
    info_shift: "Aberto 24/7",
    amenities: amenities_list.sample(3), # Seleciona 3 amenidades aleatórias
    capacity: 100 + i * 10 # Capacidade incremental
  )

  file = URI.open(gym_images[i])
  gym.gym_image.attach(io: file, filename: "gym_image#{i}.jpg", content_type: 'image/jpeg')

  # Anexar imagens à academia
  file1 = URI.open(additional_gym_images[i])
  gym.images.attach(io: file1, filename: "gym_image#{i}_1.jpg", content_type: 'image/jpeg')

  file2 = URI.open(additional_gym_images[i+1])
  gym.images.attach(io: file2, filename: "gym_image#{i}_2.jpg", content_type: 'image/jpeg')

  if gym.save
    gym # Retorna o objeto `Gym` salvo
  else
    puts "Erro ao salvar academia: #{gym.errors.full_messages.join(", ")}"
    nil # Retorna nil em caso de falha
  end
end.compact # Remove valores `nil` do array


puts "Academias criadas: #{gyms.compact.map(&:name)}"
# Criar 50 compromissos (check-ins)
50.times do |i|
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
