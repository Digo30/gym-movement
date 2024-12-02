class GymsController < ApplicationController

  def index
    @gyms = Gym.all
    time_now = Time.current
    @time_now = Time.current
    one_hour_ago = 1.hour.ago

    @fluxos = @gyms.map do |gym|
      [gym.id, gym.appointments.where("checkin_date = ? AND checkin_hour BETWEEN ? AND ?", Date.today, one_hour_ago, time_now).count]
    end.to_h

    @gender = @gyms.map do |gym|
      gender_count = gym.appointments.joins(:user)
                      .where("checkin_date = ? AND checkin_hour BETWEEN ? AND ?", Date.today, one_hour_ago, time_now)
                      .group("users.gender")
                      .count("users.gender")
      gender_count.default = 0
      [gym.id, gender_count]
    end.to_h
  end
end
