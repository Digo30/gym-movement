class CreateGyms < ActiveRecord::Migration[7.1]
  def change
    create_table :gyms do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :phone
      t.string :email
      t.integer :rating
      t.text :info_shift
      t.string :amenities
      t.integer :capacity
      t.text :photos

      t.timestamps
    end
  end
end
