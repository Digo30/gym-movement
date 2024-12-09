class GeminiService
  include HTTParty
  base_uri 'https://generativelanguage.googleapis.com/v1'

  def initialize
    @api_key = ENV['GOOGLE_GEMINI_API_KEY']
  end

  def generate_response(message)
    endpoint = "/models/gemini-pro:generateContent"

    response = self.class.post(
      "#{endpoint}?key=#{@api_key}",
      body: request_body(message),
      headers: {
        'Content-Type' => 'application/json'
      }
    )

    if response.success?
      parse_response(response)
    else
      handle_error(response)
    end
  rescue StandardError => e
    Rails.logger.error "Erro na API do Gemini: #{e.message}"
    "Desculpe, ocorreu um erro ao processar sua mensagem."
  end

  private

  def request_body(message)
    {
      contents: [
        {
          parts: [
            {
              text: message
            }
          ]
        }
      ]
    }.to_json
  end

  def parse_response(response)
    data = JSON.parse(response.body)
    data.dig('candidates', 0, 'content', 'parts', 0, 'text') || "Não foi possível gerar uma resposta."
  end

  def handle_error(response)
    error_message = JSON.parse(response.body)['error']['message'] rescue "Erro desconhecido"
    Rails.logger.error "Erro na API do Gemini: #{error_message}"
    "Desculpe, ocorreu um erro ao processar sua mensagem."
  end
end
