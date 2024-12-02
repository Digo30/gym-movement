class AddDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthday, :date
    add_column :users, :gender, :string
    add_column :users, :phone, :string
    add_column :users, :user_image, :text
  end
end
