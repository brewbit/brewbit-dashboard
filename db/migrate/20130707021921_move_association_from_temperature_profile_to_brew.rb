class MoveAssociationFromTemperatureProfileToBrew < ActiveRecord::Migration
  def up
    add_column :brews, :temperature_profile_id, :integer
    add_index :brews, :temperature_profile_id
  end

  def down
    remove_column :brews, :temperature_profile_id, :integer
    add_index :temperature_profiles, :brew_id
  end
end
