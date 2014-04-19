class AddUuidToDeviceSessions < ActiveRecord::Migration
  def change
    add_column :device_sessions, :uuid, :string
  end
end
