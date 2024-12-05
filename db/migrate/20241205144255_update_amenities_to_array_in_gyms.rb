class UpdateAmenitiesToArrayInGyms < ActiveRecord::Migration[7.1]
  def change
    change_column :gyms, :amenities, :text, array: true, default: [], using: 'amenities::text[]'
  end
end
