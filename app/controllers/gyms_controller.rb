class GymsController < ApplicationController

  before_action :set_gym, only: [:show]
  before_action :set_date_hour, only: [:index, :show]

  def index
    if params[:query].present?
      @gyms = Gym.where("name ILIKE ?", "%#{params[:query]}%") # Filtra academias pelo nome
    else
      @gyms = Gym.all
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
