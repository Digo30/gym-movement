class AppointmentsController < ApplicationController

  def create
    @gym = Gym.find(params[:gym_id])

    check = current_user.appointments.where("checkin_date = ? AND gym_id = ?", Date.today, params[:gym_id]).exists?
    if !check
      @appointment = @gym.appointments.new(appointment_params)
      @appointment.user = current_user

      if @appointment.save
        redirect_to  gym_appointment_path(@gym, @appointment)
      else
        render :new
      end
    else
      flash[:alert] = "Você já realizou um check-in hoje!"
      redirect_to gym_path(@gym)
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
