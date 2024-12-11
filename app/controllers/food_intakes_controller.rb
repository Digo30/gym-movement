class FoodIntakesController < ApplicationController
  before_action :authenticate_user!

  def new
    # Formulário para buscar alimentos
  end

  def create
    search_term = params[:search_term]

    # Verificar se o search_term é um número (código de barras)
    if search_term.match?(/\A\d+\z/)
      # Busca por código de barras
      food = OpenFoodFactsService.search_by_barcode(search_term)
    else
      # Busca por nome do produto
      food = OpenFoodFactsService.search_by_name(search_term)
    end

    Rails.logger.debug "Dados do produto: #{food.inspect}"  # Adicionando o log aqui

    if food.present?
      product_name = food['product_name']
      calories = food.dig('nutriments', 'energy-kcal')
      protein = food.dig('nutriments', 'proteins')
      product_image = food.dig('selected_images', 'front', 'display', 'fr')

      # Check if all required fields are present
      if product_name.blank? || calories.blank? || protein.blank? || product_image.blank?
        flash.now[:alert] = "Dados do produto incompletos. Verifique o nome, calorias, proteína ou imagem do produto."
        render :new, status: :unprocessable_entity
        return
      end

      food_intake = current_user.food_intakes.new(
        product_name: product_name,
        calories: calories,
        protein: protein,
        date: Date.today,
        product_image: product_image
      )

      if food_intake.save
        redirect_to nutri_food_intakes_path, notice: "Alimento registrado com sucesso!"
      else
        flash.now[:alert] = "Erro ao registrar o alimento: #{food_intake.errors.full_messages.join(', ')}"
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Produto não encontrado. Verifique o nome ou o código de barras."
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @food_intakes = current_user.food_intakes.order(date: :desc)
    @total_calories = @food_intakes.sum(:calories)
    @total_protein = @food_intakes.sum(:protein)
  end

  def destroy
    @food_intake = current_user.food_intakes.find(params[:id])
    @food_intake.destroy
    redirect_to food_intakes_path, notice: "Alimento excluído com sucesso!"
  end
end
