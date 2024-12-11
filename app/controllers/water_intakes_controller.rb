class WaterIntakesController < ApplicationController
  before_action :authenticate_user!

  def new
    @water_intake = current_user.water_intakes.build
  end

  def create
    @water_intake = current_user.water_intakes.build(water_intake_params)
    if @water_intake.save
      redirect_to nutri_food_intakes_path, notice: "Registro de água adicionado com sucesso!"
    else
      render :new
    end
  end

  private

  def water_intake_params
    params.require(:water_intake).permit(:amount, :date)
  end
end
