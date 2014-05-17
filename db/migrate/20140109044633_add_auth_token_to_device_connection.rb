class AddAuthTokenToDeviceConnection < ActiveRecord::Migration
  def change
    add_column :device_connections, :auth_token, :string
  end
end
