class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update]


  def my_account
    @user = current_user
  end

  def trainings
    @trainings = current_user.trainings.order(created_at: :desc)
  end

  def edit
  end

  def trainings
    @trainings = current_user.trainings.order(created_at: :desc) # ActiveRecord Query
  end


  def update
  if user_params[:profile_picture].present?
    current_user.profile_picture.purge if current_user.profile_picture.attached?
  end

  if current_user.update(user_params)
    Rails.logger.info "Imagem anexada? #{current_user.profile_picture.attached?}"
    redirect_to my_account_path, notice: 'Perfil atualizado com sucesso!'
  else
    render :edit, alert: 'Erro ao atualizar o perfil.'
  end
  end


  private

  def set_user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :profile_picture, :birthday)
  end

end
