class CreateTrainings < ActiveRecord::Migration[6.0]
  def change
    unless table_exists?(:trainings)
      create_table :trainings do |t|
        t.string :title
        t.text :description
        t.integer :duration
        t.references :user, null: false, foreign_key: true
        t.timestamps
      end
    end
  end
end
