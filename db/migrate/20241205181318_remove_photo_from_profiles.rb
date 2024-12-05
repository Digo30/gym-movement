class RemovePhotoFromProfiles < ActiveRecord::Migration[7.1]
  def change
    remove_column :profiles, :photo, :text
  end
end
