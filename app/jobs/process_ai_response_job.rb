class ProcessAiResponseJob < ApplicationJob
  queue_as :default

  def perform(message)
    # Integração com Gemini AI
      ai_response = GeminiService.new.generate_response(message.content)

      # Salva a resposta do AI
      ai_message = message.user.chat_messages.create(
        content: ai_response,
        sender: 'ai'
      )

      Turbo::StreamsChannel.broadcast_append_to(
      message.user,
      target: "messages",
      partial: "chat_messages/chat_message", locals: { chat_message: ai_message })

  end
end
