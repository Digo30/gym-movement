class GymsController < ApplicationController
  before_action :set_gym, only: [:show]
  before_action :set_date_hour, only: [:index, :show]

  def index
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
      amenities_filter = params[:amenities].map(&:strip) # Remover espaços antes e depois
      # Filtro pelo operador @> para arrays
      @gyms = @gyms.where("amenities @> ARRAY[:amenities]::text[]", amenities: amenities_filter)
    end

    @gyms = @gyms.order(:name)

    @fluxos = @gyms.map do |gym|
      [gym.id, gym.appointments.where("checkin_date = ? AND checkin_hour BETWEEN ? AND ?", Date.today, @one_hour_ago, @time_now).count]
    end.to_h

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
      amenities_filter = params[:amenities].split(',').map(&:strip) # Garante que amenities seja um array
      @gyms = @gyms.where("amenities @> ARRAY[:amenities]::text[]", amenities: amenities_filter)
    end

    # Criando os marcadores com base nos filtros
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
  end


  def show
    # Pegar as imagens de perfil de quem esta na academia
    @images = @gym.appointments.joins(:user)
      .where("checkin_date = ? AND checkin_hour BETWEEN ? AND ?", Date.today, @one_hour_ago, @time_now)
      .pluck('users.user_image')
      .first(3)

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

  private

  def set_gym
    @gym = Gym.find(params[:id])
  end

  def set_date_hour
    @time_now = Time.current
    @one_hour_ago = 1.hour.ago
  end
end
