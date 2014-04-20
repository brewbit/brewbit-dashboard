
module ControllerSettingsService

  def self.create( device, settings )

    current_session = device.active_session_for settings[:sensor_index]
    if current_session
      current_session.active = false
      current_session.save!
    end

    device_session_params = {
      name: settings[:name],
      device_id: device.id,
      sensor_index: settings[:sensor_index],
      setpoint_type: settings[:setpoint_type],
      static_setpoint: settings[:static_setpoint],
      temp_profile_id: settings[:temp_profile_id],
      output_settings_attributes: []
    }

    settings[:output_settings].each do |output_setting|
      device_session_params[:output_settings_attributes] << {
        output_index: output_setting[:index],
        function: output_setting[:function],
        cycle_delay: output_setting[:cycle_delay]
      }
    end

    device_session = DeviceSession.new(device_session_params)
    device_session.active = true

    device_session
  end
end

