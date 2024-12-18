class GymsController < ApplicationController
  before_action :set_gym, only: [:show, :chat, :alunos]
  before_action :set_date_hour, only: [:index, :show, :alunos]

  def index
    @gyms = Gym.all

    # Filtro por nome
    if params[:query].present?
      @gyms = @gyms.where("name ILIKE ?", "%#{params[:query]}%")
    end

    # Filtro por comodidades
    if params[:amenities].present?
      amenities_filter = params[:amenities].map(&:strip) # Remover espaços antes e depois
      # Filtro pelo operador @> para arrays
      @gyms = @gyms.where("amenities @> ARRAY[:amenities]::text[]", amenities: amenities_filter)
    end

    @gyms = @gyms.order(:name)

    # Filtro por lotação
    if params[:max_lotacao].present?
      max_lotacao = params[:max_lotacao].to_i
      @gyms = @gyms.to_a.select do |gym|
        fluxo = gym.appointments.where("checkin_date = ? AND checkin_hour BETWEEN ? AND ?", Date.today, @one_hour_ago, @time_now).count
        (fluxo.to_f / gym.capacity.to_f) * 100 <= max_lotacao
      end
    end

    @fluxos = @gyms.map do |gym|
      [gym.id, gym.appointments.where("checkin_date = ? AND checkin_hour BETWEEN ? AND ?", Date.today, @one_hour_ago, @time_now).count]
    end.to_h


    @gender = @gyms.map do |gym|
      gender_count = gym.appointments.joins(:user)
                      .where("checkin_date = ? AND checkin_hour BETWEEN ? AND ?", Date.today, @one_hour_ago, @time_now)
                      .group("users.gender")
                      .count("users.gender")
      gender_count.default = 0
      [gym.id, gender_count]
    end.to_h
  end

  def map
    @gyms = Gym.all

    # Filtro por nome
    if params[:query].present?
      @gyms = @gyms.where("name ILIKE ?", "%#{params[:query]}%")
    end

    # Filtro por lotação
    if params[:capacity].present?
      @gyms = @gyms.where("capacity >= ?", params[:capacity].to_i)
    end

    # Filtro por comodidades
    if params[:amenities].present?
      amenities_filter = params[:amenities].split(',').map(&:strip)
      @gyms = @gyms.where("amenities @> ARRAY[:amenities]::text[]", amenities: amenities_filter)
    end

    # Criando os marcadores
    @markers = @gyms.geocoded.map do |gym|
      {
        lat: gym.latitude,
        lng: gym.longitude,
        name: gym.name,
        capacity: gym.capacity,
        amenities: gym.amenities,
        info_window_html: render_to_string(partial: "info_window", locals: { gym: gym })
      }
    end

    # Localização do usuário
    @user_location = { lat: request.env["HTTP_X_FORWARDED_FOR"], lng: request.remote_ip } # Para demonstração, você pode obter a localização real com JavaScript
  end


  def show
    # Pegar as imagens de perfil de quem esta na academia
    @images = @gym.appointments.joins(:user)
      .where("checkin_date = ? AND checkin_hour BETWEEN ? AND ?", Date.today, @one_hour_ago, @time_now)
      .limit(3)
      .map { |appointment| url_for(appointment.user.profile_picture) if appointment.user.profile_picture.attached? }
      .compact

    # Pegar a quantidade de homens e mulheres na academia
    @fluxo = @gym.appointments.joins(:user)
      .where("checkin_date = ? AND checkin_hour BETWEEN ? AND ?", Date.today, @one_hour_ago, @time_now)
      .group("users.gender")
      .count("users.gender")

    # Pegar a quantidade de alunos na academia fora os 3 com a imagem na página
    check_alunos = (@fluxo["Male"].to_i + @fluxo["Female"].to_i) - 3
    @qtd_alunos = check_alunos > 3 ? check_alunos : nil

    @fluxo_medio = (check_alunos + 3) * 100  / @gym.capacity

    @fluxo = @gym.appointments.joins(:user)
      .where("checkin_date = ? AND checkin_hour BETWEEN ? AND ?", Date.today, @one_hour_ago, @time_now)
      .group("users.gender")
      .count("users.gender")

    @fluxo_medio = (@fluxo["Male"].to_i + @fluxo["Female"].to_i) * 100 / @gym.capacity

    # Limpar colchetes e espaços em torno das comodidades
    @amenities = @gym.amenities.map { |amenity| amenity.gsub(/[\[\]\s]/, '') }
  end

  def chat
    @messages = @gym.messages.includes(:user).order(created_at: :asc)
  end

  def alunos
    @alunos = @gym.appointments.joins(:user)
    .where("checkin_date = ? AND checkin_hour BETWEEN ? AND ?", Date.today, @one_hour_ago, @time_now)
  end

  private

  def set_gym
    @gym = Gym.find(params[:id])
  end

  def set_date_hour
    @time_now = Time.current
    @one_hour_ago = 48.hours.ago
  end
end
