class AddTimeToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :appointment_time, :time
  end
end
