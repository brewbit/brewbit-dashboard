class AddTemperatureProfileReferenceToTemperatureProfilePoints < ActiveRecord::Migration
  def change
    add_column :temperature_profile_points, :temperature_profile_id, :integer
    add_index :temperature_profile_points, :temperature_profile_id
  end
end
