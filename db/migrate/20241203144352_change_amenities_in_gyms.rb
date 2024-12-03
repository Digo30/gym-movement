class ChangeAmenitiesInGyms < ActiveRecord::Migration[7.1]
  def up
    # Converta os valores existentes para o formato esperado (string separada por vírgulas)
    Gym.find_each do |gym|
      if gym.amenities.is_a?(Array)
        amenities_string = gym.amenities.join(', ')
        gym.update_column(:amenities, amenities_string)
      end
    end
  end

  def down
    # Reverta a conversão de volta para um array (se necessário)
    Gym.find_each do |gym|
      if gym.amenities.is_a?(String)
        amenities_array = gym.amenities.split(',').map(&:strip)
        gym.update_column(:amenities, amenities_array)
      end
    end
  end
end
