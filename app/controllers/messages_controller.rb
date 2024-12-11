class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_gym

  def create
    @message = @gym.messages.build(message_params)
    @message.user = current_user
    if @message.save
      redirect_to chat_gym_path(@gym), notice: 'Mensagem enviada com sucesso.'
    else
      redirect_to chat_gym_path(@gym), alert: 'Erro ao enviar a mensagem.'
    end
  end

  def destroy
    @message = @gym.messages.find(params[:id])
    @message.destroy
    redirect_to chat_gym_path(@gym), notice: 'Mensagem excluída com sucesso.'
  end

  private

  def set_gym
    @gym = Gym.find(params[:gym_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
