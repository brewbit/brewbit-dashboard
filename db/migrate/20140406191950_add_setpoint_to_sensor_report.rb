class AddSetpointToSensorReport < ActiveRecord::Migration
  def change
    add_column :sensor_readings, :setpoint, :float
  end
end
