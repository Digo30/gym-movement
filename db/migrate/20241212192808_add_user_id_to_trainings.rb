class AddUserIdToTrainings < ActiveRecord::Migration[7.2]
  def change
    add_column :trainings, :user_id, :bigint
    add_index :trainings, :user_id
  end
end
