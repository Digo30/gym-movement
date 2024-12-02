class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.date :checkin_date
      t.time :checkin_hour
      t.date :checkout_date
      t.time :checkout_hour
      t.boolean :active
      t.references :user, null: false, foreign_key: true
      t.references :gym, null: false, foreign_key: true

      t.timestamps
    end
  end
end
