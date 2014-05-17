class CreateDeviceConnections < ActiveRecord::Migration
  def change
    create_table :device_connections do |t|
      t.string :socket_id
      t.string :device_id

      t.timestamps
    end

    add_index :device_connections, :socket_id, unique: true
    add_index :device_connections, :device_id, unique: true
  end
end
