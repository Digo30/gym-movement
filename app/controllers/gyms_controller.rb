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
        lng: gym.longitude
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
    @markers = @gyms.geocoded.map do |gym|
      {
        lat: gym.latitude,
        lng: gym.longitude
      }
    end
  end

  def show
    @images = @gym.appointments.joins(:user)
      .where("checkin_date = ? AND checkin_hour BETWEEN ? AND ?", Date.today, @one_hour_ago, @time_now)
      .pluck('users.user_image').sample(3)

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
