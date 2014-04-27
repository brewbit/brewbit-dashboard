#
# Defaults
#
# name                  - Randomly generated
# hardware_identifier   - <provided>
#
class Defaults
  def self.build_device( activation_token, hardware_identifier, name = 'Model-T' )
    attr = {
      activation_token: activation_token,
      hardware_identifier: hardware_identifier,
      name: "#{name} #{spree_current_user.devices.count + 1}",
      output_count: 2,
      sensor_count: 2,
      control_mode: Device::CONTROL_MODE[:on_off],
      hysteresis: 1
    }

    device = Device.new attr

    device
  end

  def self.build_device_session( device, scale = 'F', name = '' )
    attr = {
      device: device,
      name: name,
      sensor_index: 0,
      setpoint_type: DeviceSession::SETPOINT_TYPE[:static],
      static_setpoint: ( 'F' == scale ? 68 : 20 )
    }
    device_session = DeviceSession.new attr

    (0...device.output_count).each do |output_index|
      build_output_settings( device_session, output_index, OutputSettings::FUNCTIONS[:heating] )
  end

    device_session
  end

  def self.build_output_settings( device_session, output_index, function = Output::FUNCTIONS[:heating], cycle_delay = 3 )
    attr = {
      device_session: device_session,
      output_index: output_index,
      function: function,
      cycle_delay: cycle_delay
    }
    output_settings = OutputSettings.new attr
    device_session.output_settings << output_settings
  end
end

