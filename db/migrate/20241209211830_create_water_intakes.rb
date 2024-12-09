class CreateWaterIntakes < ActiveRecord::Migration[7.2]
  def change
    create_table :water_intakes do |t|
      t.decimal :amount
      t.date :date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
