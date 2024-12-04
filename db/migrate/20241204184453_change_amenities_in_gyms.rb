class ChangeAmenitiesInGyms < ActiveRecord::Migration[7.1]
  def up
    # Corrigir os valores armazenados para o formato adequado de array literal
    Gym.find_each do |gym|
      if gym.amenities.is_a?(String)
        # Remover os colchetes desnecessários se existirem
        amenities_string = gym.amenities.gsub(/[{}"]/,'')
        amenities_array = amenities_string.split(',').map(&:strip)
        formatted_amenities = "{#{amenities_array.join(',')}}"
        gym.update_column(:amenities, formatted_amenities) # Atualiza o campo com o formato correto
      end
    end

    # Alterando o tipo da coluna amenities para text[] (array de texto)
    execute 'ALTER TABLE gyms ALTER COLUMN amenities TYPE text[] USING amenities::text[]'

    # Definindo o valor padrão para a coluna
    change_column_default :gyms, :amenities, []
  end

  def down
    # Revertendo a conversão do array de volta para string
    Gym.find_each do |gym|
      if gym.amenities.is_a?(Array)
        amenities_string = gym.amenities.join(', ') # Converte array em string separada por vírgulas
        gym.update_column(:amenities, amenities_string) # Atualiza o campo no banco
      end
    end

    # Revertendo o tipo da coluna para string
    execute 'ALTER TABLE gyms ALTER COLUMN amenities TYPE string USING amenities::string'

    # Revertendo o valor padrão
    change_column_default :gyms, :amenities, ""
  end
end
