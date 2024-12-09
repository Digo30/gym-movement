class ChatMessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    message = current_user.chat_messages.build(message_params)

    if message.save
      ProcessAiResponseJob.perform_later(message)
      render turbo_stream: turbo_stream.append(:messages, partial: "chat_messages/chat_message", locals: { chat_message: message })

      # # Integração com Gemini AI
      # ai_response = GeminiService.new.generate_response(message.content)

      # # Salva a resposta do AI
      # ai_message = current_user.chat_messages.create(
      #   content: ai_response,
      #   sender: 'ai'
      # )

      # render turbo_stream: [
      #   turbo_stream.append(:messages,
      #   partial: "chat_messages/chat_message",
      #   locals: { chat_message: message }),
      #   turbo_stream.append(:messages,
      #   partial: "chat_messages/chat_message",
      #   locals: { chat_message: ai_message })
      # ]




    else
      redirect_to chat_path, alert: 'Erro ao enviar mensagem'
    end
  end

  private

  def message_params
    params.require(:chat_message).permit(:content).merge(sender: 'user')
  end
end
