class AddProductImageToFoodIntakes < ActiveRecord::Migration[7.2]
  def change
    add_column :food_intakes, :product_image, :string
  end
end
