class DropDeviceConnection < ActiveRecord::Migration
  def change
    drop_table :device_connections
  end
end
