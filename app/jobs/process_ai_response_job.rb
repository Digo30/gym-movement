class ProcessAiResponseJob < ApplicationJob
  queue_as :default

  def perform(message)
    # Integração com Gemini AI
    ai_response = GeminiService.new.generate_response(message.content)

    # Salva a resposta da IA como uma nova mensagem no chat
    ai_message = message.user.chat_messages.create(
      content: ai_response,
      sender: 'ai'
    )

    # Salva o treino no modelo Training apenas se for uma mensagem de treino
    if message.content.include?("Estou criando uma tabela de treino")
      Training.create!(
        title: "Treino de #{extract_focus_area(message.content)} - #{Time.current.strftime('%d/%m/%Y')}",
        content: ai_response,
        user: message.user,
        created_at: Time.current
      )
    end

    Turbo::StreamsChannel.broadcast_append_to(
      message.user,
      target: "messages",
      partial: "chat_messages/chat_message",
      locals: { chat_message: ai_message }
    )
  end

  private

  def extract_focus_area(content)
    content.match(/focado em (\w+)/)&.captures&.first || "Treino"
  end
end
