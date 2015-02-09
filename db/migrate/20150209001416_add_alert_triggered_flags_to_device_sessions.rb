class AddAlertTriggeredFlagsToDeviceSessions < ActiveRecord::Migration
  def change
    add_column :device_sessions, :high_temp_alert_triggered, :boolean, default: false
    add_column :device_sessions, :low_temp_alert_triggered, :boolean, default: false
    add_column :device_sessions, :comms_loss_alert_triggered, :boolean, default: false
  end
end
