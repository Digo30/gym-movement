class AddLogoToGym < ActiveRecord::Migration[7.1]
  def change
    add_column :gyms, :logo, :text
  end
end
