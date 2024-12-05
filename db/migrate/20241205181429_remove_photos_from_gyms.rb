class RemovePhotosFromGyms < ActiveRecord::Migration[7.1]
  def change
    remove_column :gyms, :photos, :text
  end
end
