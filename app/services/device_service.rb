class DeviceService

  def self.send_activation_notification(device)
    options = {
      device_id:  device.hardware_identifier,
      auth_token: device.user.authentication_token
    }
    
    device_post device, 'activation/complete', options
  end
  
  def self.send_command(device, command)
    data = {
      name: command.name,
      outputs: [],
      sensors: [],
      temp_profiles: []
    }
    command.output_settings.each do |o|
      output = {
        index:            o.output.output_index,
        function:         o.function,
        cycle_delay:      o.cycle_delay,
        sensor_index:     o.sensor.sensor_index,
        output_mode:      o.output_mode
      }
      data[:outputs] << output
    end
    command.sensor_settings.each do |s|
      sensor = {
        index:            s.sensor.sensor_index,
        setpoint_type:    s.setpoint_type
      }
      case s.setpoint_type
      when Sensor::SETPOINT_TYPE[:static]
        sensor[:static_setpoint] = s.static_setpoint
      when Sensor::SETPOINT_TYPE[:temp_profile]
        sensor[:temp_profile_id] = s.temp_profile_id
        temp_profile = {
          id:           s.temp_profile.id,
          name:         s.temp_profile.name,
          start_value:  s.temp_profile.start_value,
          steps:        s.temp_profile.steps.collect { |step| {
              duration: step.duration_for_device,
              value:    step.value,
              type:     step.step_type
            }
          }
        }
        data[:temp_profiles] << temp_profile
      end
      data[:sensors] << sensor
    end

    Rails.logger.debug "Sending device command: #{data.inspect}"
    device_post device, 'commands', data
  end
  
  private
  
  def device_post( device, path, query_opts = {} )
    # TODO resque errors
    HTTParty.post( "#{DEVICE_GATEWAY_API_URL}/devices/#{device.hardware_identifier}/#{path}", query: query_opts )
  end
end