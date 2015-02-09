
module AlertService

  def self.check(session)
    # check for high temp alert condition
    unless session.high_temp_threshold.nil?
      high_temp_threshold = (session.last_setpoint + session.high_temp_threshold)
      
      if session.high_temp_alert_triggered
        if session.last_reading < high_temp_threshold
          session.high_temp_alert_triggered = false
          # send temp normal notification
        end
      else
        if session.last_reading > high_temp_threshold
          session.high_temp_alert_triggered = true
          Brewbit::AlertsMailer.high_temp_alert(session).deliver
        end
      end
    end
    
    # check for low temp alert condition
    unless session.low_temp_threshold.nil?
      low_temp_threshold = (session.last_setpoint - session.low_temp_threshold)
      
      if session.low_temp_alert_triggered
        if session.last_reading > low_temp_threshold
          session.low_temp_alert_triggered = false
          # send temp normal notification
        end
      else
        if session.last_reading < low_temp_threshold
          session.low_temp_alert_triggered = true
          Brewbit::AlertsMailer.low_temp_alert(session).deliver
        end
      end
    end
  end
end
