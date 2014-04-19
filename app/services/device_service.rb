require 'json'

class DeviceService
  DEVICE_GATEWAY_API_URL = 'http://localhost:10080'

  def self.send_activation_notification(device)
    options = {
      auth_token: device.user.authentication_token
    }
    
    response = device_post device, 'activation', options
    unless response.code == 200
      raise "Error sending activation notification to device: #{JSON.parse(response.body)["message"]}"
    end
  end
  
  def self.send_device_settings(device)
    data = {
      name: device.name,
      control_mode: device.control_mode
    }
    
    Rails.logger.debug "Sending device settings: #{data.inspect}"
    response = device_post device, 'device_settings', data
    unless response.code == 200
      raise "Error sending device settings to device: #{JSON.parse(response.body)["message"]}"
    end
    end
  
  def self.send_session(device, session)
    data = {
      name: session.name,
      sensor_index: session.sensor_index,
      setpoint_type: session.setpoint_type,
      output_settings: [],
      temp_profiles: []
      }
    
    case session.setpoint_type
    when DeviceSession::SETPOINT_TYPE[:static]
      data[:static_setpoint] = session.static_setpoint
    when DeviceSession::SETPOINT_TYPE[:temp_profile]
      data[:temp_profile_id] = session.temp_profile_id
        temp_profile = {
        id:           session.temp_profile.id,
        name:         session.temp_profile.name,
        start_value:  session.temp_profile.start_value,
        steps:        session.temp_profile.steps.collect { |step| {
              duration: step.duration_for_device,
              value:    step.value,
              type:     step.step_type
            }
          }
        }
        data[:temp_profiles] << temp_profile
      end
    
    session.output_settings.each do |o|
      output_settings = {
        index:            o.output_index,
        function:         o.function,
        cycle_delay:      o.cycle_delay
      }
      data[:output_settings] << output_settings
    end

    Rails.logger.debug "Sending device session: #{data.inspect}"
    response = device_post device, 'controller_settings', data
    unless response.code == 200
      raise "Error sending session to device: #{JSON.parse(response.body)["message"]}"
    end
  end
  
  def self.destroy(device)
    device_delete device
  end
  
  private
  
  def self.device_post( device, path, options = {} )
    # TODO resque errors
    HTTParty.post( "#{DEVICE_GATEWAY_API_URL}/devices/#{device.hardware_identifier}/#{path}", body: options.to_json )
  end
  
  def self.device_delete( device )
    # TODO resque errors
    HTTParty.delete( "#{DEVICE_GATEWAY_API_URL}/devices/#{device.hardware_identifier}" )
  end
end