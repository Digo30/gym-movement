class AddProteinToFoodIntakes < ActiveRecord::Migration[7.2]
  def change
    add_column :food_intakes, :protein, :float
  end
end
