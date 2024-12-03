class AppointmentsController < ApplicationController

  def create
    @gym = Gym.find(params[:gym_id])
    @appointment = @gym.appointments.new(appointment_params)
    @appointment.user = current_user

    if @appointment.save
      redirect_to  gym_appointment_path(@gym, @appointment)
    else
      render :new
    end
  end

  def show
    @gym = Gym.find(params[:gym_id])
  end


  private

  def appointment_params
    params.require(:appointment).permit(:checkin_date, :checkin_hour)
  end
end
