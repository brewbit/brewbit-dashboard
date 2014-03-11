class RenameTemperatureProfilePointsToTemperaturePoints < ActiveRecord::Migration
  def up
    rename_table :temperature_profile_points, :temperature_points
  end

  def down
    rename_table :temperature_points, :temperature_profile_points
  end
end
