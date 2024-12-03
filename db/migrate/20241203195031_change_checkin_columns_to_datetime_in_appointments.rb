class ChangeCheckinColumnsToDatetimeInAppointments < ActiveRecord::Migration[7.1]
  def change
    change_column :appointments, :checkin_hour, 'timestamp', using: "CURRENT_DATE + checkin_hour::interval"
  end
end
