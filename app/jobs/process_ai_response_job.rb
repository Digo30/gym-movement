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

    # Atualiza o campo `ai_generated_list` no modelo User
    message.user.update(ai_generated_list: ai_response)

    # Envia a mensagem para o Turbo Stream no front-end
    Turbo::StreamsChannel.broadcast_append_to(
      message.user,
      target: "messages",
      partial: "chat_messages/chat_message", locals: { chat_message: ai_message }
    )
  end
end
