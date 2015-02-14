class AddCommsListAtToDeviceSessions < ActiveRecord::Migration
  def change
    add_column :device_sessions, :comms_lost_at, :datetime
  end
end
