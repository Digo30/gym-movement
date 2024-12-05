class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def index
    @profiles = current_user.profiles
    @profile = current_user.profiles.new
  end

  def create
    @profile = current_user.profiles.new(profile_params)
    if @profile.save
      flash[:notice] = "Dados atualizados com sucesso!"
      redirect_to profiles_path
      #redirect_to my_account_path
    else
      flash[:alert] = "Erro ao atualizar as informações."
      render :index
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:weight, :height, photos: [])
  end
end
