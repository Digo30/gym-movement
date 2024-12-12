class CreateTrainings < ActiveRecord::Migration[7.2]
  def change
    create_table :trainings do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end