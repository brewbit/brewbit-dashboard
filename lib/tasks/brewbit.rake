namespace :brewbit do
  desc "Searches for sessions that have reached their connection timeout and sends email alerts"
  task check_device_connections: :environment do
    expired_sessions = Brewbit::DeviceSession.where("active = ? AND comms_loss_threshold IS NOT NULL AND comms_loss_alert_triggered = ? AND comms_lost_at < ?", true, false, DateTime.now)
    puts "found #{expired_sessions.length} expired sessions"
    expired_sessions.each do |session|
      session.comms_loss_alert_triggered = true
      session.save!
      
      Brewbit::AlertsMailer.comms_loss_alert(session).deliver
    end
  end
end
