class RemoveImagesFromGyms < ActiveRecord::Migration[7.1]
  def change
    remove_column :gyms, :images, :text
  end
end
