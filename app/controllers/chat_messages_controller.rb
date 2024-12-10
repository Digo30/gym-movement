class ChatMessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    if params[:focus_area].present? && params[:sessions_per_week].present? && params[:experience].present?
      content = "Estou criando uma tabela de treino para você focado em #{params[:focus_area]} no nível #{params[:experience]} com treinos de #{params[:sessions_per_week]} vez(es) por semana."
    else
      content = message_params[:content]
    end

    message = current_user.chat_messages.build(content: content, sender: 'user')

    if message.save
      # Processa a resposta da IA
      ProcessAiResponseJob.perform_later(message)
      render turbo_stream: turbo_stream.append(:messages, partial: "chat_messages/chat_message", locals: { chat_message: message })
    else
      redirect_to chat_path, alert: 'Erro ao enviar mensagem'
    end
  end

  def update_ai_generated_list(message, ai_response)
    current_user.update(ai_generated_list: ai_response) if message.sender == 'ai'
  end

  private

  def message_params
    params.require(:chat_message).permit(:content).merge(sender: 'user')
  end
end
