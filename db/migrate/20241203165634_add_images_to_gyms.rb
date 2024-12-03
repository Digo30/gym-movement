class AddImagesToGyms < ActiveRecord::Migration[7.1]
  def change
    add_column :gyms, :images, :jsonb, default: []
  end
end
