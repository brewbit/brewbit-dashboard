class RenameDeviceCommandToDeviceSession < ActiveRecord::Migration
  def change
    rename_table :device_commands, :device_sessions
    rename_column :output_settings, :device_command_id, :device_session_id
    rename_column :sensor_settings, :device_command_id, :device_session_id
  end
end
