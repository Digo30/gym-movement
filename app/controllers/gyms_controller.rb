class GymsController < ApplicationController

  before_action :set_gym, only: [:show]
  before_action :set_date_hour, only: [:index, :show]

  def index
    @gyms = Gym.all
      respond_to do |format|
        format.html  # Responde com a visualização padrão
        format.js    # Responde com JavaScript (para atualizações dinâmicas)
      end

    # Busca por nome
    if params[:query].present?
      @gyms = @gyms.where("name ILIKE ?", "%#{params[:query]}%")
    end

    # Filtro por distância (exemplo com coordenadas)
    # if params[:distance].present?
    #   user_latitude = params[:latitude] || 0 # Substituir pela localização real do usuário
    #   user_longitude = params[:longitude] || 0
    #   @gyms = @gyms.near([user_latitude, user_longitude], params[:distance].to_f)
    # end

    # # Filtro por lotação
    # if params[:capacity].present?
    #   @gyms = @gyms.where("capacity <= ?", params[:capacity].to_i)
    # end

    # Filtro por comodidades
    if params[:amenities].present?
      @gyms = @gyms.where("amenities @> ARRAY[?]::varchar[]", params[:amenities])
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

  def show
    @images = @gym.appointments.joins(:user)
        .where("checkin_date = ? AND checkin_hour BETWEEN ? AND ?", Date.today, @one_hour_ago, @time_now)
        .pluck('users.user_image') .sample(3)
    @fluxo = @gym.appointments.joins(:user)
    .where("checkin_date = ? AND checkin_hour BETWEEN ? AND ?", Date.today, @one_hour_ago, @time_now)
    .group("users.gender")
    .count("users.gender")
    @fluxo_medio = (@fluxo["Male"].to_i + @fluxo["Female"].to_i) * 100  / @gym.capacity

    @amenities = @gym.amenities.split(',')
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
