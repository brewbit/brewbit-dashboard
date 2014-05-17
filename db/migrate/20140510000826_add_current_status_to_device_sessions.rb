class AddCurrentStatusToDeviceSessions < ActiveRecord::Migration
  def change
    add_column :device_sessions, :last_reading, :float
    add_column :device_sessions, :last_setpoint, :float
  end
end
