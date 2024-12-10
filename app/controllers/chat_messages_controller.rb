class ChatMessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    # Se o formulário foi preenchido com foco e frequência
    
    if params[:focus_area].present? && params[:sessions_per_week].present? && params[:experience].present?
      content = "Estou criando uma tabela de treino para você focado em #{params[:focus_area]} no nível #{params[:experience]} com treinos de #{params[:sessions_per_week]} vez(es) por semana. #{@weight}"
    else
      content = message_params[:content] # Caso seja uma mensagem comum
    end

    # Cria a mensagem
    message = current_user.chat_messages.build(content: content, sender: 'user')

    if message.save
      ProcessAiResponseJob.perform_later(message) # Envia para a IA
      render turbo_stream: turbo_stream.append(:messages, partial: "chat_messages/chat_message", locals: { chat_message: message })
    else
      redirect_to chat_path, alert: 'Erro ao enviar mensagem'
    end
  end

  private

  def message_params
    params.require(:chat_message).permit(:content).merge(sender: 'user')
  end
end
