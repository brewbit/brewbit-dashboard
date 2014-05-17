class AddActiveFlagToDeviceSessions < ActiveRecord::Migration
  def change
    add_column :device_sessions, :active, :boolean
  end
end
