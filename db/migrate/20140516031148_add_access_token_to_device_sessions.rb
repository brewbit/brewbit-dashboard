class AddAccessTokenToDeviceSessions < ActiveRecord::Migration
  def change
    add_column :device_sessions, :access_token, :string
    
    DeviceSession.reset_column_information

    DeviceSession.all.each do |session|
      session.touch
      session.save
    end
  end
end
