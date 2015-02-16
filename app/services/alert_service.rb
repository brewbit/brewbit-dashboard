
module AlertService

  def self.check(session)
    # check for comms regained alert condition
    if session.comms_loss_alert_triggered
      session.comms_loss_alert_triggered = false
      Brewbit::AlertsMailer.comms_loss_alert_cleared(session).deliver
    end
    
    # Update comms_lost_at time
    if session.comms_loss_threshold.nil?
      session.comms_lost_at = nil
    else
      session.comms_lost_at = DateTime.now + session.comms_loss_threshold.minutes
    end
  
    # check for high temp alert condition
    unless session.high_temp_threshold.nil?
      high_temp_threshold = (session.last_setpoint + session.high_temp_threshold)
      
      if session.high_temp_alert_triggered
        if session.last_reading < high_temp_threshold
          session.high_temp_alert_triggered = false
          Brewbit::AlertsMailer.high_temp_alert_cleared(session).deliver
        end
      else
        if session.last_reading > high_temp_threshold
          session.high_temp_alert_triggered = true
          Brewbit::AlertsMailer.high_temp_alert_triggered(session).deliver
        end
      end
    end
    
    # check for low temp alert condition
    unless session.low_temp_threshold.nil?
      low_temp_threshold = (session.last_setpoint - session.low_temp_threshold)
      
      if session.low_temp_alert_triggered
        if session.last_reading > low_temp_threshold
          session.low_temp_alert_triggered = false
          Brewbit::AlertsMailer.low_temp_alert_cleared(session).deliver
        end
      else
        if session.last_reading < low_temp_threshold
          session.low_temp_alert_triggered = true
          Brewbit::AlertsMailer.low_temp_alert_triggered(session).deliver
        end
      end
    end
  end
end
