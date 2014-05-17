class RenameTemperaturesToSensorReadings < ActiveRecord::Migration
  def change
    rename_table :temperatures, :sensor_readings
  end
end
