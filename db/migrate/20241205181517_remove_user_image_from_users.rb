class RemoveUserImageFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :user_image, :text
  end
end
