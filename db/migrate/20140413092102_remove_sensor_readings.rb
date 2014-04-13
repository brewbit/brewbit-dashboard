class RemoveSensorReadings < ActiveRecord::Migration
  def change
    drop_table :sensor_readings
  end
end
