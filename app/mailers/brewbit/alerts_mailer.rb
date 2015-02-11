module Brewbit
  class AlertsMailer < ActionMailer::Base
    default from: 'brewbit@brewbit.com'
    layout 'alert_email'

    def low_temp_alert(session)
      @user = session.device.user
      @session = session
      @temp_threshold = session.last_setpoint - session.low_temp_threshold

      mail(to: @user.email, subject: 'Low Temperature Alert from your BrewBit Model-T')
    end

    def high_temp_alert(session)
      @user = session.device.user
      @session = session
      @temp_threshold = session.last_setpoint + session.high_temp_threshold

      mail(to: @user.email, subject: 'High Temperature Alert from your BrewBit Model-T')
    end
  end
end