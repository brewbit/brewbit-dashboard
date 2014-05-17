class MoveSensorSettingsIntoDeviceSession < ActiveRecord::Migration
  def change
    add_column :device_sessions, :sensor_index, :integer
    add_column :device_sessions, :setpoint_type, :integer
    add_column :device_sessions, :static_setpoint, :float
    add_column :device_sessions, :temp_profile_id, :integer
    drop_table :sensor_settings
  end
end
