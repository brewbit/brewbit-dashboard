class AddSensorSettingsIdToSensorReadings < ActiveRecord::Migration
  def change
    add_column :sensor_readings, :sensor_settings_id, :integer
    add_index :sensor_readings, :sensor_settings_id
  end
end
