class FixAmenitiesFormat < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      UPDATE gyms
      SET amenities = REPLACE(REPLACE(amenities, '[', '{'), ']', '}')
      WHERE amenities IS NOT NULL;
    SQL
  end

  def down
    execute <<-SQL
      UPDATE gyms
      SET amenities = REPLACE(REPLACE(amenities, '{', '['), '}', ']')
      WHERE amenities IS NOT NULL;
    SQL
  end
end
