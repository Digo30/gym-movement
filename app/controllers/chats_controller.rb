class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @messages = current_user.chat_messages.order(created_at: :asc)
  end

  def create
    @message = current_user.chat_messages.build(message_params)

    if @message.save
      # Integração com Gemini AI
      ai_response = GeminiService.new.generate_response(@message.content)

      # Salva a resposta do AI
      @ai_message = current_user.chat_messages.create(
        content: ai_response,
        sender: 'ai'
      )

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path }
      end
    else
      redirect_to chat_path, alert: 'Erro ao enviar mensagem'
    end
  end

  private

  def message_params
    params.require(:chat_message).permit(:content).merge(sender: 'user')
  end
end
