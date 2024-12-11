class CreateFoodIntakes < ActiveRecord::Migration[7.2]
  def change
    create_table :food_intakes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :product_name
      t.integer :calories
      t.date :date

      t.timestamps
    end
  end
end
