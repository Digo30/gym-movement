require 'httparty'
require 'cgi' # Adicione essa linha

class OpenFoodFactsService
  include HTTParty
  base_uri 'https://world.openfoodfacts.org'

  # Busca por código de barras
  def self.search_by_barcode(barcode)
    response = get("/api/v0/product/#{CGI.escape(barcode)}.json", query: { lang: 'pt' })
    if response.code == 200 && response.parsed_response['product']
      response.parsed_response['product']
    else
      nil
    end
  end

  # Busca por nome do produto
  def self.search_by_name(product_name)
    response = get('/cgi/search.pl', query: { search_terms: product_name, search_simple: 1, action: 'process', json: 1 })
    if response.code == 200 && response.parsed_response['products'].present?
      response.parsed_response['products'].first # Retorna o primeiro produto encontrado
    else
      nil
    end
  end
end
